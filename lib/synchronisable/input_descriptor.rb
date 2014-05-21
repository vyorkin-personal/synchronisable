module Synchronisable
  class InputDescriptor
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def empty?
      @data.blank?
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
