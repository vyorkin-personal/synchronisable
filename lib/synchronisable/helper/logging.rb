module Synchronisable
  module Helper
    # Provides logging helper methods.
    # Class or module that includes this one
    # should implement `logger` method.
    #
    # @api private
    module Logging
      protected

      %i(verbose colorize).each do |name|
        define_method("#{name}_logging?".to_sym) do
          Synchronisable.config.logging[name]
        end
      end

      def log_info(msg, color = :white, force = true)
        text = msg.colorize(color) if colorize_logging?
        logger.info(text) if force || verbose_logging?
      end
    end
  end
end
