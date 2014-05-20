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
      @data.is_a?(Enumerable) && (
        element_class.is_a?(String) ||
        element_class.is_a?(Integer)
      )
    end

    def element_class
      @element_class ||= @data.try(:first).try(:class)
    end
  end
end
