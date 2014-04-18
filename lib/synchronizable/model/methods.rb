require 'synchronizable/worker'
require 'synchronizable/models/import'

module Synchronizable
  module Model
    # Methods that will be attached to synchronizable model class.
    module Methods
      # Creates a new worker, that initiates synchronization
      # for this particular model.
      #
      # @param data [Array<Hash>] array of hashes with remote attriutes
      #
      # @see Synchronizable::Worker
      def sync(data)
        Worker.run(self, data)
      end

      # Count of import records for this model.
      def imports_count
        Import.where(synchronizable_type: self).count
      end
    end
  end
end
