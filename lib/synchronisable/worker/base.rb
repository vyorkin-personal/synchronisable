require 'synchronisable/helper/logging'

module Synchronisable
  module Worker
    # Base class for synchronization workers.
    #
    # @see Synchronisable::Worker::Record
    # @see Synchronisable::Worker::Associations
    #
    # @api private
    class Base
      include Helper::Logging

      def initialize(synchronizer, source)
        @synchronizer, @source = synchronizer, source
        @includes = source.includes
      end

      def logger
        @synchronizer.logger
      end
    end
  end
end
