module Synchronizable
  module DSL
    # Allows to define DSL-like attributes (options)
    # to be used in target class/module.
    #
    # @example Common use cases
    # class Foo
    #   include Synchronizable::DSL::Option
    #
    #   option :bar, default: 1
    #   option :x, :y, :z
    #   option :f, -> {
    #     ...
    #   }
    # end
    #
    # @api private
    module Option
      extend ActiveSupport::Concern

      included do
        class_attribute :options
        self.options = {}
      end

      module ClassMethods
        # Defines a new option.
        #
        # @overload option(attrs, options)
        #  @param attrs [Array] attributes
        #  @param options [Hash] options
        #    @option options :default default value
        # @overload option(attrs)
        #
        # @see {Synchronizable::Synchronizer::Base}
        #
        # @api private
        def option(*args)
          opts = args.extract_options!
          args.each { |attr| define_option(attr.to_sym, opts) }
        end

        private

        def define_option(name, opts)
          options[name] = eval_if_proc(opts[:default])

          define_singleton_method(name) do |value = nil|
            options[name] = prepare(value, opts) if value.present?
            options[name]
          end
        end

        def prepare(value, opts)
          converter = opts[:converter]
          value = converter.call(value) if converter
          eval_if_proc(value)
        end

        def eval_if_proc(value)
          value.is_a?(Proc) ? value.call : value
        end
      end
    end
  end
end
