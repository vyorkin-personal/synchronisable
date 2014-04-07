# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ar_remote_synchronizer/version'

Gem::Specification.new do |spec|
  spec.name          = "ar_remote_synchronizer"
  spec.version       = ArRemoteSynchronizer::VERSION::STRING
  spec.authors       = ["Vasiliy Yorkin"]
  spec.email         = ["vasiliy.yorkin@gmail.com"]
  spec.description   = "Provides base fuctionality (models, DSL) for AR synchronization with external resources (apis, services etc)"
  spec.summary       = spec.description
  spec.homepage      = "https://git.undev.cc/vyorkin/ar_remote_synchronizer"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activerecord",  ">= 3.0.0"
  spec.add_runtime_dependency "activesupport", ">= 3.0.0"

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
  spec.add_development_dependency "factory_girl"
  spec.add_development_dependency "factory_girl_sequences"
  spec.add_development_dependency "database_cleaner"
end
