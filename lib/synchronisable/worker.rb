require 'pry-byebug'
require 'colorize'

require 'synchronisable/error_handler'
require 'synchronisable/context'
require 'synchronisable/input_dispatcher'
require 'synchronisable/source'
require 'synchronisable/models/import'
require 'synchronisable/helper/logging'

module Synchronisable
  # Responsible for model synchronization.
  #
  # @api private
  class Worker
    include Helper::Logging

    attr_reader :logger

    class << self
      # Creates a new instance of worker and initiates model synchronization.
      #
      # @overload run(model, data, options)
      #   @param model [Class] model class to be synchronized
      #   @param options [Hash] synchronization options
      #   @option options [Hash] :include assocations to be synchronized.
      #     Use this option to override `has_one` & `has_many` assocations
      #     defined in model synchronizer.
      # @overload run(model, data)
      # @overload run(model)
      #
      # @return [Synchronisable::Context] synchronization context
      def run(model, *args)
        options = args.extract_options!
        data = args.first

        new(model, options).run(data)
      end
    end

    # Initiates model synchronization.
    #
    # @param data [Array<Hash>] array of hashes with remote attriutes.
    #   If not specified worker will try to get the data
    #   using defined gateway class or `fetch` lambda/proc
    #   defined in corresponding synchronizer
    #
    # @return [Synchronisable::Context] synchronization context
    #
    # @see Synchronisable::InputDispatcher
    def run(data)
      sync do |context|
        error_handler = ErrorHandler.new(@logger, context)
        context.before = @model.imports_count

        hashes = InputDispatcher.dispatch(@model, @synchronizer, data)
        hashes.each do |attrs|
          source = Source.new(@model, @parent, attrs)

          error_handler.handle(source) do
            @synchronizer.with_sync_callbacks(source) do
              sync_record(source)
              set_record_foreign_keys(source)
              sync_associations(source)
            end
          end
        end

        context.after = @model.imports_count
        context.deleted = 0
      end
    end

    private

    def initialize(model, options)
      @model, @synchronizer = model, model.synchronizer
      @logger = @synchronizer.logger
      @parent = options[:parent]
    end

    def sync
      @logger.progname = "#{@model} synchronization"
      log_info('STARTING', :yellow, true)

      context = Context.new(@model, @parent.try(:model))
      yield context

      log_info('DONE', :yellow, true)
      log_info(context.summary_message, :cyan, true)

      context
    end

    # Method called by {#run} for each remote model attribute hash
    #
    # @param source [Synchronisable::Source] synchronization source
    #
    # @return [Boolean] `true` if synchronization was completed
    #   without errors, `false` otherwise
    def sync_record(source)
      @synchronizer.with_record_sync_callbacks(source) do
        source.prepare

        log_info(source.dump_message, :green)

        if source.updatable?
          log_info("updating #{@model}: #{source.local_record.id}", :blue)
          source.update_record
        else
          source.create_record_pair
          log_info("#{@model} (id: #{source.local_record.id}) was created", :blue)
          log_info("#{source.import_record.class}: #{source.import_record.id} was created", :blue)
        end
      end
    end

    def set_record_foreign_keys(source)
      reflection = belongs_to_parent_reflection
      return unless reflection

      belongs_to_key = "#{reflection.plural_name.singularize}_id"
      source.local_record.update_attributes!(
        belongs_to_key => @parent.local_record.id
      )
    end

    # Synchronizes associations.
    #
    # @param source [Synchronisable::Source] synchronization source
    #
    # @see Synchronisable::DSL::Associations
    # @see Synchronisable::DSL::Associations::Association
    def sync_associations(source)
      return if source.associations.blank?
      log_info("starting associations sync", :blue)

      source.associations.each do |association, ids|
        ids.each { |id| sync_association(source, id, association) }
      end
    end

    def sync_association(source, id, association)
      log_info("synchronizing association with id: #{id}", :blue)

      @synchronizer.with_association_sync_callbacks(source, id, association) do
        attrs = association.model.synchronizer.find(id)
        Worker.run(association.model, [attrs], { :parent => source })
      end
    end

    # Finds a `belongs_to` reflection to the parent model.
    #
    # @see ActiveRecord::Reflection::AssociationReflection
    def belongs_to_parent_reflection
      return unless @parent

      model_reflections.find do |r|
        r.macro == :belongs_to &&
        r.plural_name == @parent.model.table_name
      end
    end

    def model_reflections
      @model.reflections.values
    end
  end
end
