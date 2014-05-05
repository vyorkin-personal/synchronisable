require 'synchronizable/dsl/macro/expression'

module Synchronizable
  module DSL
    module Macro
      # Expression for an attribute definition.
      #
      # @api private
      #
      # @see Synchronizable::DSL::Macro
      # @see Synchronizable::DSL::Expression
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

