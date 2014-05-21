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
        @synchronizer.fetch
      when ->(i) { i.remote_id? }
        @synchronizer.find(data)
      when ->(i) { i.local_id? }
        find_by_local_id(data)
      when ->(i) { i.array_of_ids? }
        find_by_array_of_ids(input)
      else
        result = data.dup
      end

      [result].flatten.compact
    end

    private

    def find_by_array_of_ids(input)
      records = find_imports(input.element_class.name, input.data)
      records.map { |r| @synchronizer.find(r.remote_id) }
    end

    def find_by_local_id(id)
      import = @model.find_by(id: id).try(:import)
      import ? @synchronizer.find(import.remote_id) : nil
    end

    private

    def find_imports(class_name, ids)
      case class_name
      when 'Fixnum'
        ids.map { |id| @model.find_by(id: id).try(&:import) }
      when 'String'
        ids.map { |id| Import.find_by(id: id) }
      end
    end
  end
end
