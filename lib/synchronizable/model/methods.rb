require 'synchronizable/worker'
require 'synchronizable/models/import'

module Synchronizable
  module Model
    # Methods that will be attached to synchronizable model class.
    module Methods
      # Creates a new worker, that initiates synchronization
      # for this particular model.
      # If you have implemented `fetch` & `find` methods
      # in your model synchronizer, than it will be used if no data supplied.
      #
      # @overload sync(data, options)
      #   @param options [Hash] synchronization options
      #   @option options [Hash] :include assocations to be synchronized.
      #     Use this option to override `has_one` & `has_many` assocations
      #     defined in model synchronizer.
      # @overload sync(options)
      # @overload sync(data)
      # @overload sync
      #
      # @param data [Array<Hash>] array of hashes with remote attributes.
      #
      # @see Synchronizable::Worker
      #
      # @example Supplying array of hashes with remote attributes
      #   FooModel.sync([
      #     {
      #       :id => '123',
      #       :attr1 => 4,
      #       :attr2 => 'blah'
      #     },
      #     ...
      #   ])
      #
      # @example General usage
      #   FooModel.sync(:include => {
      #     :assocation_model => :nested_assocaiton_model
      #   })
      #
      # @example Football domain use case
      #   Match.sync(:include => {
      #     :match_players => :player
      #   })
      def sync(*args)
        Worker.run(self, *args)
      end

      # Count of import records for this model.
      def imports_count
        Import.where(synchronizable_type: self).count
      end
    end
  end
end
