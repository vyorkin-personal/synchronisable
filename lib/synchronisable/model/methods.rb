require 'synchronisable/controller'
require 'synchronisable/models/import'

module Synchronisable
  module Model
    # Methods that will be attached to synchronisable model class.
    module Methods
      # Creates a new controller, that initiates synchronization
      # for this particular model and its associations.
      # If you have implemented `fetch` & `find` methods
      # in your model synchronizer, than it will be used if no data supplied.
      #
      # @overload sync(data, options)
      #   @param data [Array<Hash>, Array<String>, Array<Integer>, String, Integer] synchronization data
      #   @param options [Hash] synchronization options
      #   @option options [Hash] :include assocations to be synchronized.
      #     Use this option to override `has_one` & `has_many` assocations
      #     defined in model synchronizer.
      # @overload sync(options)
      # @overload sync(data)
      # @overload sync
      #
      #
      # @see Synchronisable::Controller
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
        Controller.call(self, *args)
      end

      # Count of import records for this model.
      def imports_count
        Import.where(synchronisable_type: self).count
      end
    end
  end
end
