Synchronizable.configure do |config|
  # Logging configuration
  #
  # config.logging = {
  #   :verbose  => true,
  #   :colorize => true
  # }

  # If you want to restrict synchronized models.
  # By default it will try to sync all models that have
  # a `synchronizable` dsl instruction.
  #
  # config.models = %w(Foo Bar)
end
