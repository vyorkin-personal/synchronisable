module Synchronizable
  module DSL
    extend ActiveSupport::Concern

    module ClassMethods
      # Declare this on your model class to make it synchronizable.
      # After that you can call {#sync} start model synchronization.
      #
      # @overload synchronizable(klass, options)
      #   @param klass [Class] synchronizer class to be used
      #   @param options [Hash] describes behavior of synchronizable model
      #   @option options [Boolean] :destroy_missed if set to `true` than
      #     all local records that don't have corresponding remote counterpart
      #     will be destroyed
      #   @option options [Boolean] :if lambda that allow to specify if
      #     synchronization should occur
      #   @option options [Boolean] :unless the negative of :if
      # @overload synchronizable(options)
      #   @param options [Hash] describes behavior of synchronizable model
      #   @option options [Class] :synchronizer class that provides
      #     synchronization configuration
      # @overload synchronizable
      #
      # @see Synchronizable::Synchronizer::Base
      #
      # @example Common usage
      #   class FooModel < ActiveRecord::Base
      #     synchronizable BarSynchronizer
      #                    destroy_missed: false,
      #                    if: -> { bar? }
      #   end
      def synchronizable(*args)
        @logger = create_logger
        @synchronizer = create_synchronizer(args)

        has_one :import, as: :synchronizable
      end

      # Initiates model synchronization
      #
      # @param data [Array<Hash>] array of hashes with remote attributes
      #
      # @return [Hash] summary info about synchronization result
      def sync(data)
        errors = []
        @logger.info { 'starting' }
        data.each { |attrs| @synchronizer.sync(data, errors) }
        @logger.info { 'done' }
        errors
      end

      private

      def create_synchronizer(args)
        options = args.extract_options!
        set_default_options!(options)

        synchronizer_class(args, options)
          .new(self.name, options)
      end

      def set_default_options!(options)
        options.reverse_merge!({
          :destroy_missed => true,
          :on => %w(create update destroy)
        })
      end

      def synchronizer_class(args, options)
        args.first || options[:synchronizer] ||
          "#{self.name.demodulize}Synchronizer".constantize
      end

      def create_logger
        logger = defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
        logger.progname = "#{self.name} synchronization"
        logger
      end
    end
  end
end
