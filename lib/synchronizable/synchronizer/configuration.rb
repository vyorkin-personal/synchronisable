module Synchronizable
  module Synchronizer
    module Configuration
      extend ActiveSupport::Concern

      included do
        class_attribute :remote_id, :mappings

        self.remote_id = :id
        self.mappings = {}
      end

      module ClassMethods
        # Configures the mappings between local model and
        # its remote counterpart attributes
        #
        # @overload configure(remote_id, mappings)
        #   @param remote_id [Symbol] the remote id attribute name
        #   @param mappings [Hash] attribute mappings (including id attribute)
        # @overload configure(remote_id)
        #
        # @example Typical usage
        #   class BarSynchronizer < Synchronizable::Synchronizer::Base
        #     configure :di, {
        #       :di   => :id,
        #       :eman => :name
        #     }
        #   end
        def configure(remote_id = :id, mappings = {})
          self.remote_id = remote_id
          self.mappings  = mappings
        end
      end
    end
  end
end
