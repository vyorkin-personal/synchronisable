require 'i18n'

locale_paths = File.join(File.dirname(__FILE__),
                         '..', 'locale', '*.yml')

Dir[locale_paths].each { |path| I18n.load_path << path }
I18n.backend.load_translations unless defined?(Rails)

I18n.config.enforce_available_locales = true
I18n.default_locale = :en
I18n.available_locales = [:en, :ru]
