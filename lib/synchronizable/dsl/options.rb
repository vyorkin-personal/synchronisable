require 'synchronizable/dsl/options/option'

require 'pry-byebug'

module Synchronizable::DSL
  # Allows to define DSL-like attributes (options)
  # to be used in target class/module.
  #
  # @example Common use cases
  #   class Foo
  #     include Synchronizable::DSL::Options
  #
  #     option :bar, default: 1
  #     option :blah, default: -> { bar * 2 }
  #     option :x, :y, :z
  #     option :f, -> {
  #       ...
  #     }
  #     option :w, converter: ->(h) { x.with_indifferent_access }
  #   end
  #
  # @api private
  #
  # @see Synchronizable::DSL::Options::Option
  module Options
    extend ActiveSupport::Concern

    included do |base|
      class_attribute :class_options
      self.class_options = {
        base => {}
      }
    end

    module ClassMethods
      def inherited(subclass)
        class_options[subclass] = class_options[self].dup
      end

      # Defines a new option.
      #
      # @overload option(*attrs, opts)
      #  @param attrs [Array] attributes
      #  @param opts [Hash] options
      #  @option options :default default value,
      #    procs & lambdas are lazily evaluated.
      #  @option options [Lambda] :converter method that
      #    will be lazily applied to the source value in order to convert it
      #    to the desired type
      # @overload option(*attrs)
      #
      # @api private
      #
      # @see Synchronizable::Synchronizer
      # @see Synchronizable::DSL::Options::Option
      def option(*args)
        opts = args.extract_options!
        args.each { |attr| define_option(attr.to_sym, opts) }
      end

      private

      def define_option(name, options)
        class_options[self][name] = Option.new(options)

        define_singleton_method(name) do |*args, &block|
          if args.present? || block
            class_options[self][name].save(args, &block)
          else
            class_options[self][name].value
          end
        end
      end
    end
  end
end
