require 'synchronizable/model/methods'
require 'synchronizable/synchronizers/synchronizer_default'

module Synchronizable
  module Model
    extend ActiveSupport::Concern

    module ClassMethods
      SYNCHRONIZER_SUFFIX = 'Synchronizer'

      # Declare this on your model class to make it synchronizable.
      # After that you can call {Synchronizable::Model::Methods#sync} to
      # start model synchronization.
      #
      # @overload synchronizable(klass, options)
      #   @param klass [Class] synchronizer class to be used
      #   @param options [Hash] describes behavior of synchronizable model
      # @overload synchronizable(options)
      #   @param options [Hash] describes behavior of synchronizable model
      #   @option options [Class] :synchronizer class that provides
      #     synchronization configuration
      # @overload synchronizable
      #
      # @see Synchronizable::Synchronizer
      # @see Synchronizable::Model::Methods
      #
      # @example Common usage
      #   class FooModel < ActiveRecord::Base
      #     synchronizable BarSynchronizer
      #   end
      def synchronizable(*args)
        extend Synchronizable::Model::Methods

        class_attribute :synchronizer
        has_one :import, as: :synchronizable

        set_defaults(args)
      end

      private

      def set_defaults(args)
        options = args.extract_options!

        self.synchronizer = args.first ||
          options[:synchronizer] || default_synchronizer
      end

      def default_synchronizer
        # TODO: Find a better way to do this without rescuing an exception
        begin
          "#{self.name.demodulize}#{SYNCHRONIZER_SUFFIX}".constantize
        rescue NameError
          SynchronizerDefault.instance
        end
      end
    end
  end
end
