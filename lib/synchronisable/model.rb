require 'synchronisable/model/methods'
require 'synchronisable/synchronizers/synchronizer_default'

module Synchronisable
  module Model
    extend ActiveSupport::Concern

    module ClassMethods
      SYNCHRONIZER_SUFFIX = 'Synchronizer'

      # Declare this on your model class to make it synchronisable.
      # After that you can call {Synchronisable::Model::Methods#sync} to
      # start model synchronization.
      #
      # @overload synchronisable(klass, options)
      #   @param klass [Class] synchronizer class to be used
      #   @param options [Hash] describes behavior of synchronisable model
      #   @option options [Class] :synchronizer class that provides
      #     synchronization configuration
      # @overload synchronisable(options)
      # @overload synchronisable
      #
      # @see Synchronisable::Synchronizer
      # @see Synchronisable::Model::Methods
      #
      # @example Common usage
      #   class FooModel < ActiveRecord::Base
      #     synchronisable BarSynchronizer
      #   end
      def synchronisable(*args)
        extend Synchronisable::Model::Methods

        class_attribute :synchronizer
        has_one :import, as: :synchronisable, class_name: 'Synchronisable::Import'

        scope :without_import, -> {
          includes(:import)
            .where(imports: { synchronisable_id: nil })
            .references(:imports)
        }

        set_defaults(args)
      end

      private

      def set_defaults(args)
        options = args.extract_options!

        self.synchronizer = args.first || options[:synchronizer] ||
          find_synchronizer || SynchronizerDefault
      end

      def find_synchronizer
        const_name = "#{self.name.demodulize}#{SYNCHRONIZER_SUFFIX}"
        const_name.safe_constantize
      end
    end
  end
end
