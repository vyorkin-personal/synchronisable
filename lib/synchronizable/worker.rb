require 'synchronizable/error_handler'
require 'synchronizable/context'
require 'synchronizable/models/import'

require 'pry-byebug'

module Synchronizable
  # Responsible for model synchronization.
  #
  # @api private
  class Worker
    class << self
      # Creates a new instance of worker and initiates model synchronization.
      #
      # @param model [Class] model class to be synchronized
      # @param args [Array<Hash>] array of hashes with remote attributes
      #
      # @return [Synchronizable::Context] synchronization context
      #
      # @see Synchronizable::Context
      #
      # @api private
      def run(model, args)
        options = args.extract_options!
        data    = args.first

        new(model, options).run(data)
      end
    end

    # Initiates model synchronization.
    #
    # @param data [Array<Hash>] array of hashes with remote attriutes.
    #   If not specified worker will try to get the data
    #   using `fetch` lambda/proc defined in corresponding synchronizer.
    #
    # @return [Synchronizable::Context] synchronization context
    #
    # @see Synchronizable::Context
    #
    # @api private
    def run(data)
      sync do |context|
        error_handler = ErrorHandler.new(@logger, context)
        context.result.before = @model.imports_count

        data = @synchronizer.fetch.() if data.blank?
        data.each do |attrs|

          # TODO: Handle case when only array of ids is given
          # What to do with associations?

          attrs = attrs.with_indifferent_access
          error_handler.handle do
            sync_record(attrs, context)
            sync_associations(attrs, context)
          end
        end

        context.result.after = @model.imports_count
      end
    end

    private

    def initialize(model, options = {})
      @model, @synchronizer = model, model.synchronizer
      @logger = @synchronizer.logger
      @options = options
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
    # @param context [Synchronizable::Context] synchronization context
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
    def sync_record(remote_attrs, context)
      with_record_sync_callbacks(remote_attrs, context) do
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
    end

    def with_record_sync_callbacks(attrs, context)
      success = @synchronizer.before_record_sync.(attrs, context)
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
    #
    # @raise [MissedAssocationsError] raised when the given
    #   attributes hash doesn't required associations
    #
    # @see Synchronizable::DSL::Associations
    # @see Synchronizable::DSL::Associations::Association
    #
    # @api private
    def sync_associations(attrs)
      # TODO: Handle case with has_many association
      associations = @synchronizer.associations_for(attrs.keys)
      associations.each do |key, association|
        [*attrs[key]].each do |id|
          sync_association(id, association)
        end
      end
    end

    def sync_association(id, association)
      attrs = association.model.synchronizer.find.(id)
      Worker.run(association.model, *[attrs])
    end

    def verbose_logging?
      Synchronizable.logging[:verbose]
    end
  end
end
