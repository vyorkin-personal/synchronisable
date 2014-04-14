require 'synchronizable/synchronizer/configuration'

module Synchronizable
  module Synchronizer
    # @abstract Subclass for remote id & mappings configuration.
    # @see Synchronizable::Synchronizer::Configuration
    class Base
      include Synchronizable::Synchronizer::Configuration

      def initialize(model_klass, options)
        @model_klass, @options = model_klass, options
      end

      # Method called by {Synchronizable::DSL::ClassMethods#sync}
      # for each remote model attribute hash
      #
      # @param data [Hash] hash with remote attributes
      #
      # @return [Boolean] `true` if syncronization was completed
      #   without errors, `false` otherwise
      #
      # @api private
      def sync(data, errors)
        ActiveRecord::Base.transaction do
          data = data.with_indifferent_access
          remote_id = data.delete(self.class.remote_id)
          ensure_remote_id(remote_id)

          import_record = Import.find_by(
            self.class.remote_id => remote_id,
            :synchronizable_type => @model_klass
          )

          attrs = map_attributes(data)

          if import_record.present? && import_record.synchronizable.present?
            import_record.synchronizable.update_attributes!(attrs)
          else
            local_record = @model_klass.create!(attrs)
            import_record = Import.create!(
              :synchronizable_id    => local_record.id,
              :synchronizable_type  => @model_klass,
              :remote_id            => remote_id,
              :attrs                => attrs.to_json
            )
          end
          return true
        end
        rescue Exception => e
          errors << e
          log_error(e)
          return false
      end

      private

      def map_attributes(data)
        return data unless self.class.mappings.present?
        data.transform_keys { |key| self.class.mappings[key] }
      end

      def log_error(e)
        # TODO
      end

      def ensure_remote_id(id)
        unless id.present?
          raise MissedRemoteIdError, I18n.l(
            'errors.missed_remote_id',
            remote_id: self.class.remote_id
          )
        end
      end
    end
  end
end
