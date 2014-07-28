require 'synchronisable/worker/base'

module Synchronisable
  module Worker
    # Responsible for associations synchronization.
    #
    # @api private
    class Associations < Base
      # Synchronizes associations.
      #
      # @see Synchronisable::Source
      # @see Synchronisable::DSL::Associations
      # @see Synchronisable::DSL::Associations::Association
      %w(child parent).each do |type|
        define_method(:"sync_#{type}_associations") do
          associations = @source.send(:"#{type}_associations")
          log_info("starting #{type} associations sync", :blue) if associations.present?

          associations.each do |association, ids|
            ids.each { |id| send(:"sync_#{type}_association", id, association) }
          end

          log_info("done #{type} associations sync", :blue) if associations.present?
        end
      end

      private

      def sync_parent_association(id, association)
        log_info("synchronizing parent association with id: #{id}", :blue)

        @synchronizer.with_association_sync_callbacks(@source, id, association) do
          data = @source.data.try(:merge, { id: id }) || id
          Controller.call(association.model, data, {})

          import_record = Import.find_by(
            :remote_id => id.to_s,
            :synchronisable_type => association.model.to_s
          )
          @source.local_attrs[association.key] = import_record.synchronisable.id
        end
      end

      def sync_child_association(id, association)
        return unless can_sync_association?(association)

        log_info("synchronizing child association with id: #{id}", :blue)

        @synchronizer.with_association_sync_callbacks(@source, id, association) do
          data = @source.data.try(:merge, { id: id }) || id

          Controller.call(association.model, data,
            child_association_options(association))
        end
      end

      def can_sync_association?(association)
        @includes.nil? || (
          @includes.try(:include?, association.name) ||
          @includes == association.name
        )
      end

      def child_association_options(association)
        default = @includes.nil? ? nil : {}
        child_includes = @includes.try(:fetch, association.name) || default

        {
          :parent => @source,
          :includes => child_includes
        }
      end
    end
  end
end
