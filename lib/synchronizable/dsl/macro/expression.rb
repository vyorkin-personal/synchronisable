module Synchronizable
  module DSL
    module Macro
      # Serves as storage and provides lazy evaluation for expression.
      # You can override attributes in subclasses,
      # for example you can change the default value.
      #
      # @api private
      #
      # @see Synchronizable::DSL::Macro
      # @see Synchronizable::DSL::Attribute
      # @see Synchronizable::DSL::Method
      class Expression
        attr_reader :source

        def initialize(options)
          @default = options[:default]
        end

        def handle(args, &block)
          has_value = block || args.present?
          has_value ? save(args, block) : value
        end

        protected

        def default
          transform(@default)
        end

        def transform(arg)
          evaluate(arg)
        end

        private

        def save(args, block)
          if args.present?
            @source = args.count > 1 ? args : args.first
          elsif block
            @source = block
          end
        end

        def value
          source || default
        end

        def evaluate(arg)
          arg.try(:call) || arg
        end
      end
    end
  end
end
