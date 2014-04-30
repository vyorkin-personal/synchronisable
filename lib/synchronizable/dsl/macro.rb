require 'synchronizable/dsl/macro/method'
require 'synchronizable/dsl/macro/attribute'

module Synchronizable
  module DSL
    # Allows to define DSL-like attributes and methods.
    # to be used in target class/module.
    #
    # @example Common use cases
    #   class Foo
    #     include Synchronizable::DSL::Macro
    #
    #     attribute :bar, default: 1
    #     attribute :blah, default: -> { bar * 2 }
    #     attribute :x, :y, :z
    #     attribute :f, -> {
    #       ...
    #     }
    #     attribute :w, converter: ->(h) { x.with_indifferent_access }
    #     method :sqr, default: ->(x) { x * x }
    #     method :sqrt, :sin, :cos, default: -> { raise NotImplementedError }
    #   end
    #
    #   class Bar < Foo
    #     bar 4
    #     blah "blah blah"
    #
    #     sqr do |x|
    #       x * x
    #     end
    #   end
    #
    # @api private
    #
    # @see Synchronizable::Synchronizer
    # @see Synchronizable::DSL::Macro::Expression
    # @see Synchronizable::DSL::Macro::Attribute
    # @see Synchronizable::DSL::Macro::Method
    module Macro
      extend ActiveSupport::Concern

      included do |base|
        class_attribute :class_attributes
        self.class_attributes = {
          base => {}
        }
      end

      module ClassMethods
        def inherited(subclass)
          class_attributes[subclass] = class_attributes[self].deep_dup
        end

        # Defines a new attribute.
        #
        # @overload attribute(*attrs, options)
        #  @param attrs [Array] attributes
        #  @param options [Hash]
        #  @option options :default default value,
        #    procs & lambdas are lazily evaluated
        #  @option options [Lambda] :converter method that
        #    will be lazily applied to the source value in order to convert it
        #    to the desired type
        # @overload attribute(*attrs)
        #
        # @api private
        def attribute(*args)
          define_expressions(Attribute, args)
        end

        # Defines a new method.
        #
        # @overload method(*attrs, options)
        #  @param attrs [Array] attributes
        #  @param options [Hash]
        #  @option options :default default value,
        #    procs & lambdas are lazily evaluated
        # @overload method(*attrs)
        #
        # @api private
        def method(*args)
          define_expressions(Method, args)
        end

        private

        def define_expressions(klass, args)
          options = args.extract_options!
          args.each do |attr|
            name = attr.to_sym
            class_attributes[self][name] = klass.new(options)
            define_singleton_method(name) do |*params, &block|
              class_attributes[self][name].handle(params, &block)
            end
          end
        end
      end
    end
  end
end
