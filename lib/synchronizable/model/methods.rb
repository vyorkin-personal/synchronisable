require 'synchronizable/worker'
require 'synchronizable/models/import'

module Synchronizable
  module Model
    # Methods that will be attached to synchronizable model class.
    module Methods
      # Creates a new worker, that initiates synchronization
      # for this particular model.
      #
      # @overload sync(options)
      # @overload sync(data)
      # @overload sync
      #
      # @param data [Array<Hash>] array of hashes with remote attributes.
      #
      # @see Synchronizable::Worker
      def sync(*args)
        Worker.run(self, args)
      end

      # Count of import records for this model.
      def imports_count
        Import.where(synchronizable_type: self).count
      end
    end
  end
end
