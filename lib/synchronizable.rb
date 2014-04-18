require 'active_record'
require 'active_support/core_ext/hash'
require 'active_support/core_ext/class/attribute'
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

I18n.default_locale = :en
I18n.available_locales = [:en, :ru]

module Synchronizable
  include ActiveSupport::Configurable
end

ActiveSupport.on_load(:active_record) do
  include Synchronizable::Model
end
