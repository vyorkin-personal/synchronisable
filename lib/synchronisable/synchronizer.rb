require 'synchronisable/dsl/macro'
require 'synchronisable/attribute_mapper'
require 'synchronisable/dsl/associations'
require 'synchronisable/exceptions'

module Synchronisable
  # @abstract Subclass to create your model specific synchronizer class to
  #   setup synchronization attributes and behavior.
  #
  # @see Synchronisable::DSL::Macro
  # @see Synchronisable::SynchronizerDefault
  class Synchronizer
    include Synchronisable::DSL::Macro
    include Synchronisable::DSL::Associations

    SYMBOL_ARRAY_CONVERTER = ->(source) { (source || []).map(&:to_s) }

    # The name of remote `id` attribute.
    attribute :remote_id, default: :id

    # The unique id to prevent sync of duplicate records.
    method :unique_id, default: -> (attrs) { nil }

    # Mapping configuration between local model attributes and
    # its remote counterpart (including id attribute).
    attribute :mappings, converter: ->(source) {
      source.try(:with_indifferent_access)
    }

    # Attributes that will be ignored.
    attribute :except, converter: SYMBOL_ARRAY_CONVERTER

    # The only attributes that will be used.
    attribute :only, converter: SYMBOL_ARRAY_CONVERTER

    # If set to `true` than all local records that
    # don't have corresponding remote counterpart will be destroyed.
    attribute :destroy_missed, default: false

    # Logger that will be used during synchronization
    # of this particular model.
    attribute :logger, default: -> { Synchronisable.logging[:logger] }

    # Gateway to be used to get the remote data
    #
    # @see Synchronizable::Gateway
    attribute :gateway

    # Lambda that returns array of hashes with remote attributes.
    method :fetcher, default: -> (params = {}) { [] }

    # Lambda that returns a hash with remote attributes by params.
    #
    # @example Common use case
    #   class FooSynchronizer < Synchronisable::Synchronizer
    #     finder do |id|
    #       remote_source.find { |h| h[:foo_id] == id } }
    #     end
    #   end
    # @example Composite identifier
    #   class BarSynchronizer < Synchronisable::Synchronizer
    #     finder do |params|
    #       remote_source.find do |h|
    #         h[:x] == params[:x] &&
    #         h[:y] == params[:y] &&
    #         h[:z] == params[:z]
    #       end
    #     end
    #   end
    method :finder, default: -> (params) { nil }

    # Lambda, that will be called before synchronization
    # of each record and its assocations.
    #
    # @param source [Synchronisable::Source] synchronization source
    #
    # @return [Boolean] `true` to continue sync, `false` to cancel
    method :before_sync
    # Lambda, that will be called every time
    # after record and its associations is synchronized.
    #
    # @param source [Synchronisable::Source] synchronization source
    method :after_sync

    # Lambda, that will be called before synchronization of each record.
    #
    # @param source [Synchronisable::Source] synchronization source
    #
    # @return [Boolean] `true` to continue sync, `false` to cancel
    method :before_record_sync

    # Lambda, that will be called every time after record is synchronized.
    #
    # @param source [Synchronisable::Source] synchronization source
    method :after_record_sync

    # Lambda, that will be called before each association sync.
    #
    # @param source [Synchronisable::Source] synchronization source
    # @param id association remote id
    # @param association [Synchronisable::DSL::Associations::Association]
    #   association builder
    #
    # @return [Boolean] `true` to continue sync, `false` to cancel
    method :before_association_sync

    # Lambda, that will be called every time after association if synchronized.
    #
    # @param source [Synchronisable::Source] synchronization source
    # @param id association remote id
    # @param association [Synchronisable::DSL::Associations::Association]
    #   association builder
    method :after_association_sync

    class << self
      def fetch(params = {})
        data = fetcher.(params)
        data.present? ? data : gateway_instance.try(:fetch, params)
      end

      def find(params)
        data = finder.(params)
        data.present? ? data : gateway_instance.try(:find, params)
      end

      def uid(attrs)
        unique_id.is_a?(Proc) ? unique_id.(attrs) : attrs[unique_id]
      end

      # Extracts remote id from given attribute hash.
      #
      # @param attrs [Hash] remote attributes
      # @return remote id value
      #
      # @raise [MissedRemoteIdError] raised when data doesn't contain remote id
      # @see #ensure_remote_id
      #
      # @api private
      def extract_remote_id(attrs)
        id = attrs.delete(remote_id)
        ensure_remote_id(id)
      end

      # Maps the remote attributes to local model attributes.
      #
      # @param attrs [Hash] remote attributes
      # @return [Hash] local mapped attributes
      #
      # @api private
      def map_attributes(attrs)
        AttributeMapper.map(attrs, mappings, {
          :only   => only,
          :except => except,
          :keep   => associations.keys
        })
      end

      %w(sync record_sync association_sync).each do |method|
        define_method(:"with_#{method}_callbacks") do |*args, &block|
          run_callbacks(method, args, block)
        end
      end

      private

      def run_callbacks(method, args, block)
        before = send(:"before_#{method}")
        after  = send(:"after_#{method}")

        return unless before.(*args) if before
        block.()
        after.(*args) if after
      end

      # Throws the {Synchronisable::MissedRemoteIdError} if given id isn't present.
      #
      # @param id id to check
      #
      # @raise [MissedRemoteIdError] raised when data doesn't contain remote id
      def ensure_remote_id(id)
        return id.to_s if id.present?
        raise MissedRemoteIdError, I18n.t(
          'errors.missed_remote_id',
          remote_id: remote_id
        )
      end

      def gateway_instance
        @gateway_instance ||= gateway.try(:new)
      end
    end
  end
end
