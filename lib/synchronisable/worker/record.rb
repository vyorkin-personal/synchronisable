require 'synchronisable/worker/base'

module Synchronisable
  module Worker
    # Responsible for record synchronization.
    #
    # @api private
    class Record < Base
      # Synchronizes record.
      def sync_record
        @synchronizer.with_record_sync_callbacks(@source) do
          log_info(@source.dump_message, :green)

          if @source.updatable?
            log_info("updating #{@source.model}: #{@source.local_record.id}", :blue)

            update_record
          else
            create_record_pair

            log_info("#{@source.model} (id: #{@source.local_record.id}) was created", :blue)
            log_info("#{@source.import_record.class}: #{@source.import_record.id} was created", :blue)
          end
        end
      end

      private

      def update_record
        @source.import_record.update_attributes(
          remote_id: @source.remote_id,
          attrs: @source.local_attrs
        )
        @source.local_record.update_attributes!(@source.local_attrs)
      end

      def create_record_pair
        record = @source.model.create!(@source.local_attrs)
        @source.import_record = Import.create!(
          :synchronisable_id    => record.id,
          :synchronisable_type  => @source.model.to_s,
          :remote_id            => @source.remote_id.to_s,
          :unique_id            => @source.unique_id.to_s,
          :attrs                => @source.local_attrs
        )
      end
    end
  end
end
