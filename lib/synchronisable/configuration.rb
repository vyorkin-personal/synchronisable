module Synchronisable
  class Configuration
    include ActiveSupport::Configurable

    config_accessor :models do
      {}
    end
    config_accessor :logging do
      default_logger = -> { Logger.new(STDOUT) }
      rails_logger   = -> { Rails.logger || default_logger.() }

      logger = defined?(Rails) ? rails_logger.() : default_logger.()

      {
        :logger   => logger,
        :verbose  => true,
        :colorize => true
      }
    end
  end
end
