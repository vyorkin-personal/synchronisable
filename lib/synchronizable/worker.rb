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
      #
      # @return [Hash] summary info about synchronization result
      def run(model, data)
        new(model).run(data)
      end
    end

    # Initiates model synchronization.
    #
    # @param data [Array<Hash>] array of hashes with remote attriutes.
    #
    # @api private
    def run(data)
      sync do |ctx|
        data.each do |attrs|
          sync_record(ctx, attrs.with_indifferent_access)
        end
      end
    end

    private

    def initialize(model)
      @model  = model
      @logger = model.synchronizer.logger
      @error_handler = ErrorHandler.new(@logger)
    end

    def sync
      @logger.progname = "#{@model} synchronization"
      @logger.info { 'starting' }

      context = Context.new(@model)
      context.result.before = @model.imports_count

      yield context

      context.result.after = @model.imports_count

      @logger.info { 'done' }
      @logger.info { context.summary_message }
      @logger.progname = nil
    end

    # Method called by {#run} for each remote model attribute hash
    #
    # @param context [Synchronizable::Context] synchronization context
    # @param remote_attrs [Hash] hash with remote attributes
    #
    # @return [Boolean] `true` if synchronization was completed
    #   without errors, `false` otherwise
    #
    # @raise [MissedRemoteId] raised when data doesn't contain `remote_id`
    #
    # @see {Synchronizable::Context}
    # @see {Synchronizable::ErrorHandler}
    #
    # @api private
    def sync_record(context, remote_attrs)
      @error_handler.handle(context) do
        remote_id   = @model.synchronizer.extract_remote_id(remote_attrs)
        local_attrs = @model.synchronizer.map_attributes(remote_attrs)

        @logger.info { "remote id: #{remote_id}" }
        @logger.info { "remote attributes: #{remote_attrs.inspect}" }
        @logger.info { "local attributes: #{local_attrs.inspect}"   }

        import_record = Import.find_by(
          :remote_id => remote_id,
          :synchronizable_type => @model
        )

        if import_record.present? && import_record.synchronizable.present?

          @logger.info { "updating #{@model}: #{import_record.synchronizable.id}" }

          import_record.synchronizable.update_attributes!(local_attrs)
        else
          local_record = @model.create!(local_attrs)
          import_record = Import.create!(
            :synchronizable_id    => local_record.id,
            :synchronizable_type  => @model.to_s,
            :remote_id            => remote_id,
            :attrs                => local_attrs
          )

          @logger.info { "#{@model}: #{local_record.id} was created" }
          @logger.info { "#{import_record.class}: #{import_record.id} was created" }
        end
      end
    end
  end
end
