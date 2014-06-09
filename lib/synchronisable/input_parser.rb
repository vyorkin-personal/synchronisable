require 'synchronisable/input_descriptor'

module Synchronisable
  # Responsible for guessing the user input format.
  #
  # @api private
  class InputParser
    def initialize(model, synchronizer)
      @model = model
      @synchronizer = synchronizer
    end

    # Parses the user input.
    #
    # @param data [Array<Hash>, Array<String>, Array<Integer>, String, Integer]
    #   synchronization data to handle.
    #
    # @return [Array<Hash>] array of hashes with remote attributes
    def parse(data)
      input = InputDescriptor.new(data)

      result = case
      when input.empty?
        @synchronizer.fetch
      when input.remote_id?
        @synchronizer.find(data)
      when input.local_id?
        find_by_local_id(data)
      when input.array_of_ids?
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
