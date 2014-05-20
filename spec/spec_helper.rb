require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

ENV['RAILS_ENV'] ||= 'test'

require 'database_cleaner'
require 'factory_girl'
require 'factory_girl_sequences'
require 'spork'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.start
end

if ENV['TRAVIS']
  require 'coveralls'
  Coveralls.wear!
end

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'synchronisable'

require File.expand_path('../dummy/config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/its'

support_pattern   = File.join(File.dirname(__FILE__), 'synchronisable', 'support', '**', '*.rb')
factories_pattern = File.join(File.dirname(__FILE__), 'factories', '**', '*.rb')

Dir[factories_pattern].each { |file| require file }
Dir[support_pattern].each   { |file| require file }

ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)

Spork.prefork do
  RSpec.configure do |config|
    config.run_all_when_everything_filtered = true
    config.filter_run focus: true
    config.order = 'random'
    config.include FactoryGirl::Syntax::Methods

    config.before(:suite) do
      begin
        FactoryGirl.lint
      ensure
        DatabaseCleaner.clean_with(:truncation)
      end
    end

    config.before(:each) { DatabaseCleaner.strategy = :transaction }

    config.before(:each, js: true) do
      DatabaseCleaner.strategy = :truncation
    end

    config.before(:each) { DatabaseCleaner.start }
    config.after(:each)  { DatabaseCleaner.clean }

    if ENV['RUN_SLOW_TESTS'] != 'true'
      config.filter_run_excluding slow: true
    end
  end

  FactoryGirl.define do
    %w(remote match team player match_player stage tournament).each do |prefix|
      sequence(:"#{prefix}_id") { |n| "#{prefix}_#{n}" }
    end
  end
end

Spork.each_run do
end
