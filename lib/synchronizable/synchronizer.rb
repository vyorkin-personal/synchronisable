require 'synchronizable/dsl/option'
require 'synchronizable/exceptions'

module Synchronizable
  module Synchronizer
    # @abstract Subclass to setup synchronization options.
    # @see Synchronizable::DSL::Option
    class Base
      include Synchronizable::DSL::Option

      # The name of remote `id` attribute.
      option :remote_id, default: :id
      # Mapping configuration between local model attributes and
      # its remote counterpart (including id attribute).
      option :mappings, converter: ->(source) { source.with_indifferent_access }
      # If set to `true` than all local records that
      # don't have corresponding remote counterpart will be destroyed.
      option :destroy_missed, default: false
      # Attributes that will be ignored.
      option :except
      # The only attributes that will be used.
      option :only
      # Lambda that allow to specify if synchronization should occur.
      option :if
      # The opposite of `if`.
      option :unless
      # Logger that will be used during synchronization
      # of this particular model.
      # Fallbacks to `Rails.logger` if available, otherwise
      # `STDOUT` will be used for output.
      option :logger, default: -> {
        defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
      }

      class << self
        # Extracts the remote id from given attribute hash.
        #
        # @param attrs [Hash] hash of remote attributes
        # @return remote id value
        #
        # @raise [MissedRemoteIdError] raised when data doesn't contain remote id
        # @see #ensure_remote_id
        #
        # @api private
        def extract_remote_id(attrs)
          id = attrs.delete(remote_id)
          ensure_remote_id(id)
          id
        end

        # Maps the remote attributes to local model attributes.
        #
        # @param attrs [Hash] remote attributes
        # @return [Hash] local mapped attributes
        #
        # @api private
        def map_attributes(attrs)
          return attrs unless mappings.present?
          attrs.transform_keys { |key| mappings[key] }
        end

        private

        # Throws the {Synchronizable::MissedRemoteIdError} if given id isn't present.
        #
        # @param id id to check
        #
        # @raise [MissedRemoteIdError] raised when data doesn't contain remote id
        def ensure_remote_id(id)
          unless id.present?
            raise MissedRemoteIdError, I18n.t(
              'errors.missed_remote_id',
              remote_id: remote_id
            )
          end
        end
      end
    end
  end
end
