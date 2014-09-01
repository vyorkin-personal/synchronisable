Synchronisable.configure do |config|
  # Logging configuration
  #
  # Default logger fallbacks to `Rails.logger` if available, otherwise
  # `STDOUT` will be used for output.
  #
  # config.logging = {
  #   :logger   => defined?(Rails) ? Rails.logger : Logger.new(STDOUT)
  #   :verbose  => true,
  #   :colorize => true
  # }

  # If you want to restrict synchronized models.
  # By default it will try to sync all models that have
  # a `synchronisable` dsl instruction.
  #
  # config.models = %w(Foo Bar)

  # What to do with an associated import record
  # when its synchronisable is destroyed. Default is `:destroy`.
  # config.dependent_import = :destroy
end
