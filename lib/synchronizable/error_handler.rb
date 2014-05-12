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
    # @param source [Synchronizable::Source] synchronization source
    #
    # @return [Boolean] `true` if syncronization was completed
    #   without errors, `false` otherwise
    def handle(source)
      ActiveRecord::Base.transaction do
        yield
        return true
      end
      rescue Exception => e
        @context.errors << e
        log(e, source)
        return false
    end

    def log(e, source)
      @logger.error do
        I18n.t('errors.import_error',
          :model         => @context.model.to_s,
          :error         => e.message,
          :remote_attrs  => source.remote_attrs,
          :local_attrs   => source.local_attrs,
          :import_record => source.import_record.inspect,
          :local_record  => source.local_record.inspect
        )
      end
    end
  end
end
