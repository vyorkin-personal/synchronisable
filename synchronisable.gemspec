# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'synchronisable/version'

Gem::Specification.new do |spec|
  spec.name          = 'synchronisable'
  spec.version       = Synchronisable::VERSION::STRING
  spec.authors       = ['Vasiliy Yorkin']
  spec.email         = ['vasiliy.yorkin@gmail.com']
  spec.description   = 'Provides base fuctionality (models, DSL) for AR synchronization with external resources (apis, services etc)'
  spec.summary       = spec.description
  spec.homepage      = 'https://github.com/vyorkin/synchronisable'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency "activerecord",  ">= 3.0.0"
  spec.add_runtime_dependency "activesupport", ">= 3.0.0"
  spec.add_runtime_dependency "i18n"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "rails", "~> 4.0.0"
  spec.add_development_dependency "rspec-rails", "~> 3.0.0.beta2"
  # spec.add_development_dependency "rspec-given"
  spec.add_development_dependency "rspec-its"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "factory_girl_sequences"
  spec.add_development_dependency "database_cleaner"
  spec.add_development_dependency "mutant"
  spec.add_development_dependency "mutant-rspec"
  spec.add_development_dependency "guard-spork"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "simplecov"
end
