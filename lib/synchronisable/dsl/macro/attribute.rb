require 'synchronisable/dsl/macro/expression'

module Synchronisable
  module DSL
    module Macro
      # Expression for an attribute definition.
      #
      # @api private
      #
      # @see Synchronisable::DSL::Macro
      # @see Synchronisable::DSL::Expression
      class Attribute < Expression
        def initialize(options)
          @converter = options[:converter]
          super
        end

        def source
          transform(@source)
        end

        def default
          transform(@default)
        end

        protected

        def transform(arg)
          convert(super)
        end

        private

        def convert(arg)
          @converter.try(:call, arg) || arg
        end
      end
    end
  end
end

