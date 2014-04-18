module Synchronizable
  # Helper class for synchronization errors handling.
  class ErrorHandler
    def initialize(logger)
      @logger = logger
    end

    # Wraps the given block in transaction.
    # Rescued exceptions are written to log and saved to errors array.
    #
    # @param context [Synchronizable::Context] synchronization context
    #
    # @return [Boolean] `true` if syncronization was completed
    #   without errors, `false` otherwise
    def handle(context)
      ActiveRecord::Base.transaction do
        yield
        return true
      end
      rescue Exception => e
        context.errors << e
        log(e, context.model)
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
