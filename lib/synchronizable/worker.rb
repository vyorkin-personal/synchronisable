require 'synchronizable/error_handler'
require 'synchronizable/context'
require 'synchronizable/models/import'

module Synchronizable
  # Responsible for model synchronization.
  #
  # @api private
  class Worker
    class << self
      # Initiates model synchronization.
      #
      # @param model [Class] model class to be synchronized
      # @param data [Array<Hash>] array of hashes with remote attributes
      def run(model, data)
        new(model).run(data)
      end
    end

    # Initiates model synchronization.
    #
    # @param data [Array<Hash>] array of hashes with remote attriutes.
    #   If not specified worker will try to get the data
    #   using `sync` lambda/proc defined in corresponding synchronizer.
    #
    # @api private
    def run(data = nil)
      sync do |context|
        error_handler = ErrorHandler.new(@logger, context)
        context.result.before = @model.imports_count

        data = @synchronizer.fetch if data.blank?
        data.each do |attrs|
          attrs = attrs.with_indifferent_access
          error_handler.handle do
            sync_record(attrs)
            sync_associations(attrs)
          end
        end

        context.result.after = @model.imports_count
      end
    end

    private

    def initialize(model)
      @model, @synchronizer = model, model.synchronizer
      @logger = @synchronizer.logger
    end

    def sync
      @logger.progname = "#{@model} synchronization"
      @logger.info { 'starting' }

      context = Context.new(@model)
      yield context

      @logger.info { 'done' }
      @logger.info { context.summary_message }
      @logger.progname = nil

      context
    end

    # Method called by {#run} for each remote model attribute hash
    #
    # @param remote_attrs [Hash] hash with remote attributes
    #
    # @return [Boolean] `true` if synchronization was completed
    #   without errors, `false` otherwise
    #
    # @raise [MissedRemoteIdError] raised when the given
    #   attributes hash doesn't contain `remote_id`
    #
    # @see Synchronizable::ErrorHandler
    #
    # @api private
    def sync_record(remote_attrs)
      remote_id   = @synchronizer.extract_remote_id(remote_attrs)
      local_attrs = @synchronizer.map_attributes(remote_attrs)

      if verbose_logging?
        @logger.info { "remote id: #{remote_id}" }
        @logger.info { "remote attributes: #{remote_attrs.inspect}" }
        @logger.info { "local attributes: #{local_attrs.inspect}"   }
      end

      import_record = Import.find_by(
        :remote_id => remote_id,
        :synchronizable_type => @model
      )

      if import_record.present? && import_record.synchronizable.present?
        update_record(local_attrs, import_record.synchronizable)
      else
        create_record_pair(local_attrs, remote_id)
      end
    end

    def update_record(attrs, record)
      @logger.info { "updating #{@model}: #{record.id}" } if verbose_logging?

      record.update_attributes!(attrs)
    end

    def create_record_pair(attrs, remote_id)
      local_record = @model.create!(attrs)
      import_record = Import.create!(
        :synchronizable_id    => local_record.id,
        :synchronizable_type  => @model.to_s,
        :remote_id            => remote_id,
        :attrs                => attrs
      )

      if verbose_logging?
        @logger.info { "#{@model}: #{local_record.id} was created" }
        @logger.info { "#{import_record.class}: #{import_record.id} was created" }
      end
    end

    # Tries to find association keys in the given attributes hash.
    #
    # @param remote_attrs [Hash] hash with remote attributes
    # @raise [MissedAssocationsError] raised when the given
    #   attributes hash doesn't required associations
    #
    # @see Synchronizable::DSL::Associations
    # @see Synchronizable::DSL::Associations::Association
    #
    # @api private
    def sync_associations(attrs)
      associations = @synchronizer.associations_for(attrs.keys)
      associations.each do |association|
        value = attrs[association.key]
        association_attrs = association.model.synchronizer.fetch(value)

        sync_record(association_attrs)
        sync_associations(association_attrs)
      end
    end

    def verbose_logging?
      Synchronizable.logging[:verbose]
    end
  end
end
