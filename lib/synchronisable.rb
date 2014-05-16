require 'active_record'

require 'active_support/core_ext/hash'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/object/try'
require 'active_support/core_ext/object/deep_dup'
require 'active_support/core_ext/string/inflections'
require 'active_support/configurable'
require 'active_support/concern'

require 'i18n'

require 'synchronisable/version'
require 'synchronisable/models/import'
require 'synchronisable/synchronizer'
require 'synchronisable/model'

locale_paths = File.join(File.dirname(__FILE__),
  'synchronisable', 'locale', '*.yml')

Dir[locale_paths].each { |path| I18n.load_path << path }
I18n.backend.load_translations unless defined?(Rails)

I18n.config.enforce_available_locales = true
I18n.default_locale = :en
I18n.available_locales = [:en, :ru]

# The desired interface:
# ><(((*>
#
# + Model.sync
# + Model.sync([{},...])
#
# Match.sync(:include => {
#   :match_players => :player
# })
# Model.sync([id1, ..., idn])
#
# Model.where(condition).sync
# Match.where(condition).sync(:include => {
#   :match_players => :player
# })

module Synchronisable
  include ActiveSupport::Configurable

  config_accessor :models do
    {}
  end
  config_accessor :logging do
    {
      :logger   => defined?(Rails) ? Rails.logger : Logger.new(STDOUT),
      :verbose  => true,
      :colorize => true
    }
  end

  # Syncs models that is defined in {Synchronisable#models}
  #
  # @param models [Array] array of models that should be synchronized.
  #   This take a precedence over models defined in {Synchronisable#models}.
  #   If this parameter is not specified and {Synchronisable#models} is empty,
  #   than it will try to sync only those models which have a corresponding synchronizers.
  #
  # @return [Array<[Synchronisable::Context]>] array of synchronization contexts
  #
  # @see Synchronisable::Context
  def self.sync(*models)
    source = source_models(models)
    source.map(&:sync)
  end

  private

  def self.source_models(models)
    source = models.present? ? models : default_models
    source = source.present? ? source : find_models
  end

  def self.default_models
    models.map(&:safe_constantize).compact
  end

  def self.find_models
    ActiveRecord::Base.descendants.select do |model|
      model.included_modules.include?(Synchronisable::Model)
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include Synchronisable::Model
end
