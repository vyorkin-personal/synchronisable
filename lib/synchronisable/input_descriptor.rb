module Synchronisable
  # Provides a set of helper methods
  # to describe user input.
  #
  # @api private
  #
  # @see Synchronisable::InputParser
  class InputDescriptor
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def empty?
      @data.blank?
    end

    def params?
      @data.is_a?(Hash)
    end

    def remote_id?
      @data.is_a?(String)
    end

    def local_id?
      @data.is_a?(Integer)
    end

    def array_of_ids?
       enumerable? && (
        first_element.is_a?(String) ||
        first_element.is_a?(Integer)
      )
    end

    def element_class
      first_element.try(:class)
    end

    private

    def first_element
      @data.try(:first)
    end

    def enumerable?
      @data.is_a?(Enumerable)
    end
  end
end
