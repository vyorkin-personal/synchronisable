require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'yard'
require 'bundler'
require 'undev/bundler'

Bundler::GemHelper.install_tasks
RSpec::Core::RakeTask.new(:spec)
YARD::Rake::YardocTask.new

task default: :spec
task test: :spec
