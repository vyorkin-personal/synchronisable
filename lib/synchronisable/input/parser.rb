require 'synchronisable/input/descriptor'

module Synchronisable
  module Input
    # Responsible for guessing the user input format.
    #
    # @api private
    #
    # @see Synchronisable::Input::Parser
    class Parser
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
        input = Descriptor.new(data)

        result = case
                 when input.empty?
                   @synchronizer.fetch
                 when input.params?
                   find_or_fetch_by_params(input.data)
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

      def find_or_fetch_by_params(params)
        sync_method = params.key?(:id) ? :find : :fetch
        @synchronizer.send(sync_method, params)
      end

      def find_by_array_of_ids(input)
        records = find_imports(input.element_class.name, input.data)
        records.map { |r| @synchronizer.find(r.remote_id) }
      end

      def find_by_local_id(id)
        import = @model.where(id: id).first.try(:import)
        import ? @synchronizer.find(import.remote_id) : nil
      end

      def find_imports(class_name, ids)
        case class_name
        when 'Fixnum'
          ids.map { |id| @model.where(id: id).first.try(&:import) }
        when 'String'
          ids.map { |id| Import.where(id: id).first }
        end
      end
    end
  end
end
