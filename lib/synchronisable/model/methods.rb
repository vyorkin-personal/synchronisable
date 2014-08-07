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
      #   @param data [Hash, Array<Hash>, Array<String>, Array<Integer>, String, Integer] synchronization data
      #   @param options [Hash] synchronization options
      #   @option options [Hash] :includes assocations to be synchronized.
      #     Use this option to override `has_one` & `has_many` assocations
      #     defined in model synchronizer.
      # @overload sync(options)
      # @overload sync(data)
      # @overload sync
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
      #   FooModel.sync(:includes => {
      #     :assocation_model => :nested_association_model
      #   })
      #
      # @example Football domain use case
      #   Match.sync(:includes => {
      #     :match_players => :player
      #   })
      #
      # @example Here is all possible ways to call #sync
      #   Model.sync
      #   Model.sync({ :a1 => 1, :a2 => 2 })
      #   Model.sync({ :includes => {...}, :parent => xxx })
      #   Model.sync(123)
      #   Model.sync('asdf')
      #   Model.sync([{ :a1 => 1, :a2 => 2 }, { :a1 => 3, :a2 => 4 }, ...])
      #   Model.sync([123, 345, 456])
      #   Model.sync(['123', '345', '456'])
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
