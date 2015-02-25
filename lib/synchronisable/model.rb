require 'synchronisable/model/methods'
require 'synchronisable/model/scopes'
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
        extend Synchronisable::Model::Scopes

        class_attribute :synchronizer

        options = args.extract_options!

        set_defaults(options)
        set_synchronizer(args, options)

        has_one :import,
          as: :synchronisable,
          class_name: 'Synchronisable::Import',
          dependent: options[:dependent]
      end

      def synchronisable?
        false
      end

      private

      def set_defaults(options)
        options[:dependent] ||= Synchronisable.config.dependent_import
      end

      def set_synchronizer(args, options)
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
