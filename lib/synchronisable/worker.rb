require 'colorize'

require 'synchronisable/error_handler'
require 'synchronisable/context'
require 'synchronisable/source'
require 'synchronisable/models/import'

module Synchronisable
  # Responsible for model synchronization.
  #
  # @api private
  class Worker
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
    #   using `fetch` lambda/proc defined in corresponding synchronizer
    #
    # @return [Synchronisable::Context] synchronization context
    def run(data)
      sync do |context|
        error_handler = ErrorHandler.new(@logger, context)
        context.before = @model.imports_count

        data = @synchronizer.fetch.() if data.blank?
        data.each do |attrs|
          # TODO: Handle case when only array of ids is given
          # What to do with associations?

          source = Source.new(@model, @parent, attrs)
          error_handler.handle(source) do
            @synchronizer.with_sync_callbacks(source) do
              sync_record(source)
              sync_associations(source)
              set_record_foreign_keys(source)
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
      @logger.progname = nil

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
          log_info("updating #{@model}: #{source.local_record.id}", :light_green)
          source.update_record
        else
          source.create_record_pair
          log_info("#{@model} (id: #{source.local_record.id}) was created", :light_red)
          log_info("#{source.import_record.class}: #{source.import_record.id} was created", :light_red)
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
      log_info("starting associations sync", :blue) if source.associations.present?

      source.associations.each do |association, ids|
        ids.each { |id| sync_association(source, id, association) }
      end
    end

    def sync_association(source, id, association)
      log_info("synchronizing association with id: #{id}", :blue)

      @synchronizer.with_association_sync_callbacks(source, id, association) do
        attrs = association.model.synchronizer.find.(id)
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

    def log_info(msg, color = :white, force = true)
      text = msg.colorize(color) if colorize_logging?
      @logger.info(text)         if force || verbose_logging?
    end

    %i(verbose colorize).each do |name|
      define_method("#{name}_logging?".to_sym) do
        Synchronisable.logging[name]
      end
    end
  end
end
