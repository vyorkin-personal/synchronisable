require 'rspec'
require 'active_record'
require 'database_cleaner'
require 'factory_girl'
require 'factory_girl_sequences'

$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus => true
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
    config.filter_run_excluding :slow => true
  end
end

ActiveRecord::Base.establish_connection adapter: 'sqlite3', database: 'memory'

support_dir_pattern = File.join(File.dirname(__FILE__),
  'ar_remote_synchronizer', 'support', '**', '*.rb'
)

Dir[File.expand_path(support_dir_pattern)].each { |f| load f }

require 'ar_remote_synchronizer'
