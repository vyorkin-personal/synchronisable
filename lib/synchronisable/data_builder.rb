require 'synchronisable/input_descriptor'

module Synchronisable
  class DataBuilder
    class << self
      def build(model, synchronizer, data)
        new(model, synchronizer).build(data)
      end
    end

    def initialize(model, synchronizer)
      @model = model
      @synchronizer = synchronizer
    end

    def build(data)
      input = InputDescriptor.new(data)

      result = case input
      when ->(i) { i.empty? }
        @synchronizer.fetch.()
      when ->(i) { i.remote_id? }
        @synchronizer.find.(data)
      when ->(i) { i.local_id? }
        find_by_local_id(data)
      when ->(i) { i.array_of_ids? }
        find_by_array_of_ids(input.element_class, data)
      else
        result = data.dup
      end

      [result].flatten
    end

    private

    def find_by_array_of_ids(element_class, ids)
      records = case element_class
      when Integer
        ids.map { |id| @model.find_by(id: id).try(&:synchronisable) }
      when String
        ids.map { |id| Import.find_by(id: id) }
      end

      records.map { |r| @synchronizer.find.(r.id) }
    end

    def find_by_local_id(id)
      import = @model
        .find_by(id: id)
        .try(:synchronisable)

      @synchronizer.find.(import.remote_id)
    end
  end
end
