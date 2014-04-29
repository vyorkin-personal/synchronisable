module Synchronizable
  module DSL
    module Options
      # Serves as storage & provides lazy evaluation for option.
      #
      # @see Synchronizable::DSL::Options
      #
      # @api private
      class Option
        def initialize(options)
          @source = nil

          @default   = options[:default]
          @converter = options[:converter]
        end

        def save(args, &block)
          if args.present?
            @source = args.count > 1 ? args : args.first
          elsif block
            @source = block
          end
        end

        def value
          evaluate(@source) || evaluate(@default)
        end

        private

        def evaluate(arg)
          evaluated = try_evaluate(arg)
          try_convert(evaluated)
        end

        def try_evaluate(arg)
          arg.is_a?(Proc) ? arg.() : arg
        end

        def try_convert(arg)
          @converter ? @converter.(arg) : arg
        end
      end
    end
  end
end

