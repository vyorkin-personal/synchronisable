require 'active_record'

require 'active_support/core_ext/hash'
require 'active_support/core_ext/class/attribute'
require 'active_support/core_ext/string/inflections'
require 'active_support/configurable'
require 'active_support/concern'

# HACK: monkeypatches / fallbacks for activesupport ~> 3.0
if Gem.loaded_specs['activesupport'].version < Gem::Version.create(4)
  require 'active_support/core_ext/hash/deep_dup'
  require 'core_ext/object/try'
  require 'core_ext/hash/keys'
end

require 'synchronisable/bootstrap/i18n'

require 'synchronisable/version'
require 'synchronisable/configuration'
require 'synchronisable/models/import'
require 'synchronisable/synchronizer'
require 'synchronisable/model'
require 'synchronisable/gateway'

module Synchronisable
  def self.config
    @configuration ||= Configuration.new
  end

  def self.configure
    yield config
  end

  # Syncs models that are defined in {Synchronisable#models}
  #
  # @overload sync(models, options)
  #   @param models [Array] array of models that should be synchronized.
  #     This take a precedence over models defined in {Synchronisable#models}.
  #     If this parameter is not specified and {Synchronisable#models} is empty,
  #     than it will try to sync only those models which have a corresponding synchronizers
  #   @param options [Hash] options that will be passed to controller
  # @overload sync(models)
  # @overlaod sync(options)
  #
  # @return [Array<[Synchronisable::Context]>] array of synchronization contexts
  #
  # @see Synchronisable::Context
  def self.sync(*args)
    options = args.extract_options!
    source = source_models(args) 
    source.map { |model| model.sync(options) }
  end

  private

  def self.source_models(models)
    source = models.present? ? models : default_models
    source = source.present? ? source : find_models
    source.sort { |lhs, rhs| lhs.synchronizer.order <=> rhs.synchronizer.order }
  end

  def self.default_models
    config.models.map(&:safe_constantize).compact
  end

  def self.find_models
    # Need to preload models first
    Rails.application.eager_load!

    ActiveRecord::Base.descendants.select do |model|
      model.included_modules.include?(Synchronisable::Model) &&
      model.synchronisable?
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include Synchronisable::Model
end

