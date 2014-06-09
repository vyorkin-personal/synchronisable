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
          log_info("starting #{type} associations sync", :blue)

          @source.send(:"#{type}_associations").each do |association, ids|
            ids.each { |id| self.send(:"sync_#{type}_association", id, association) }
          end

          log_info("done #{type} associations sync", :blue)
        end
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
