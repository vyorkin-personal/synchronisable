module Synchronisable
  # Helper class for synchronization errors handling.
  #
  # @see Synchronisable::Context
  #
  # @api private
  class ErrorHandler
    # @param logger [Logger] logger to used to log errors
    # @param context [Synchronisable::Context] synchronization context
    def initialize(logger, context)
      @logger, @context = logger, context
    end

    # Wraps the given block in transaction if it's source for a model
    # on which #sync method was called and not a parent/child association.
    # Rescued exceptions are written to log and saved to the errors array.
    #
    # @param source [Synchronisable::Source] synchronization source
    #
    # @return [Boolean] `true` if syncronization was completed
    #   without errors, `false` otherwise
    def handle(source)
      invoke(source) do
        yield
        return true
      end
    rescue Exception => e
      err_msg = error_message(e, source)

      @context.errors << err_msg
      @logger.error err_msg

      return false
    end

    private

    # Invokes a given block.
    # Won't start a new transation if its not a "sync root".
    def invoke(source, &block)
      if source.parent
        block.()
      else
        ActiveRecord::Base.transaction(&block)
      end
    end

    def error_message(e, source)
      I18n.t('errors.import_error',
        :model         => @context.model.to_s,
        :error         => e.message,
        :backtrace     => e.backtrace.join("\n"),
        :remote_attrs  => source.remote_attrs,
        :local_attrs   => source.local_attrs,
        :import_record => source.import_record.inspect,
        :local_record  => source.local_record.inspect
      )
    end
  end
end
