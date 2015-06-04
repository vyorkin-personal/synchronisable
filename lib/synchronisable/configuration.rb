module Synchronisable
  class Configuration
    include ActiveSupport::Configurable

    class << self
      # HACK: This is required to smooth a future transition to activesupport 4.x
      # Since 3-2's config_accessor doesn't take a block or provide an option to set the default value of a config.
      alias_method :old_config_accessor, :config_accessor

      def config_accessor(*names)
        old_config_accessor(*names)
        return unless block_given?

        names.each do |name|
          send("#{name}=", yield)
        end
      end
    end

    config_accessor :dependent_import do
      :destroy
    end

    config_accessor :models do
      []
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
