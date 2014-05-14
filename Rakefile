require 'rake'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

def run_in_dummy_app(command)
  success = system("cd spec/dummy && #{command}")
  raise "#{command} failed" unless success
end

task default: :ci
task test: :spec

desc 'Run all tests for CI'
task ci: %w(db:setup spec)

namespace :db do
  desc 'Set up databases for integration testing'
  task :setup do
    puts 'Setting up databases'
    run_in_dummy_app 'rm -f db/*.sqlite3'
    run_in_dummy_app 'rake db:create db:migrate db:seed'
    run_in_dummy_app 'RAILS_ENV=test rake db:create db:migrate db:seed'
  end
end
