require 'active_record'

require 'active_support/core_ext/hash'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/object/deep_dup'
require 'active_support/core_ext/string/inflections'
require 'active_support/configurable'
require 'active_support/concern'

require 'i18n'

require 'synchronizable/version'
require 'synchronizable/models/import'
require 'synchronizable/synchronizer'
require 'synchronizable/model'

locale_paths = File.join(File.dirname(__FILE__),
  'synchronizable', 'locale', '*.yml')

Dir[locale_paths].each { |path| I18n.load_path << path }
I18n.backend.load_translations unless defined?(Rails)

I18n.config.enforce_available_locales = true
I18n.default_locale = :en
I18n.available_locales = [:en, :ru]

module Synchronizable
  include ActiveSupport::Configurable

  config_accessor :models do
    {}
  end
  config_accessor :logging do
    {
      :verbose  => true,
      :colorize => true
    }
  end

  # Syncs models that is defined in {Synchronizable#models}
  def self.sync
    # TODO: Ebash here
    #
    # 1. Get all synchronizable active record models if config.models is not defined
    # 2. Call sync for each of them
  end
end

ActiveSupport.on_load(:active_record) do
  include Synchronizable::Model
end
