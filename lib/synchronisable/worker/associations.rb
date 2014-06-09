require 'synchronisable/worker/base'

module Synchronisable
  module Worker
    # Responsible for associations synchronization.
    #
    # @api private
    class Associations < Base

      # TODO: Massive refactoring needed

      # Synchronizes associations.
      #
      # @see Synchronisable::Source
      # @see Synchronisable::DSL::Associations
      # @see Synchronisable::DSL::Associations::Association
      def sync_child_associations
        log_info('starting child associations sync', :blue)

        @source.child_associations.each do |association, ids|
          ids.each { |id| sync_child_association(id, association) }
        end

        log_info('done child associations sync', :blue)
      end

      def sync_parent_associations
        log_info('starting parent associations sync', :blue)

        @source.parent_associations.each do |association, id|
          sync_parent_association(id, association)
        end

        log_info('done parent associations sync', :blue)
      end

      private

      def sync_parent_association(id, association)
        log_info("synchronizing parent association with id: #{id}", :blue)

        @synchronizer.with_association_sync_callbacks(@source, id, association) do
          attrs = association.model.synchronizer.find(id)
          Controller.call(association.model, [attrs])

          import_record = Import.find_by(
            :remote_id => id,
            :synchronisable_type => association.model.to_s
          )
          @source.local_attrs[association.key] = model.id
        end
      end

      def sync_child_association(id, association)
        log_info("synchronizing child association with id: #{id}", :blue)

        @synchronizer.with_association_sync_callbacks(@source, id, association) do
          attrs = association.model.synchronizer.find(id)
          Controller.call(association.model, [attrs], { :parent => @source })
        end
      end
    end
  end
end
