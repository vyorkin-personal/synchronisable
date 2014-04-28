module Synchronizable
  # Helper class for synchronization errors handling.
  #
  # @see Synchronizable::Context
  #
  # @api private
  class ErrorHandler
    # @param logger [Logger] logger to used to log errors
    # @param context [Synchronizable::Context] synchronization context
    def initialize(logger, context)
      @logger, @context = logger, context
    end

    # Wraps the given block in transaction.
    # Rescued exceptions are written to log and saved to errors array.
    #
    # @return [Boolean] `true` if syncronization was completed
    #   without errors, `false` otherwise
    def handle
      ActiveRecord::Base.transaction do
        yield
        return true
      end
      rescue Exception => e
        @context.errors << e
        log(e, @context.model)
        return false
    end

    def log(e, model)
      @logger.error do
        I18n.t('errors.import_error',
          :model => model.to_s,
          :error => e.message
        )
      end
    end
  end
end
