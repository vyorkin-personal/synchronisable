lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'synchronisable/version'

Gem::Specification.new do |spec|
  spec.name          = 'synchronisable'
  spec.version       = Synchronisable::VERSION::STRING
  spec.platform      = Gem::Platform::RUBY
  spec.authors       = ['Vasiliy Yorkin']
  spec.email         = ['vasiliy.yorkin@gmail.com']
  spec.summary       = "synchronisable-#{Synchronisable::VERSION::STRING}"
  spec.description   = 'Provides base fuctionality (models, DSL) for AR synchronization with external resources (apis, services etc)'
  spec.homepage      = 'https://github.com/vyorkin/synchronisable'
  spec.files         = `git ls-files -z`.split("\x0")
  spec.bindir        = 'exe'
  spec.executables   = `git ls-files -- exe/*`.split("\n").map { |file| File.basename(file) }
  spec.test_files    = []
  spec.require_path  = 'lib'
  spec.license       = 'MIT'

  spec.add_runtime_dependency 'activerecord', '>= 3.0', '< 5.0'
  spec.add_runtime_dependency 'activesupport', '>= 3.0', '< 5.0'
  spec.add_runtime_dependency 'i18n', '~> 0.6', '>= 0.6.0'
  spec.add_runtime_dependency 'colorize', '~> 0.7', '>= 0.7.7'

  spec.add_development_dependency 'bundler', '>= 1.6.0'
  spec.add_development_dependency 'rake', '~> 10.0', '>= 10.0'
  spec.add_development_dependency 'yard', '~> 0.8', '>= 0.8.7'
  spec.add_development_dependency 'yard-rspec', '~> 0.1', '>= 0.1.0'
  spec.add_development_dependency 'rails', '>= 3.0', '< 5.0'
  spec.add_development_dependency 'rspec', '~> 3.2', '>= 3.2.0'
  spec.add_development_dependency 'rspec-rails', '~> 3.2', '>= 3.2.2'
  spec.add_development_dependency 'rspec-its', '~> 1.2', '>= 1.2.0'
  spec.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.1'
  spec.add_development_dependency 'factory_girl', '~> 4.5', '>= 4.5.0'
  spec.add_development_dependency 'factory_girl_sequences', '~> 4.3', '>= 4.3.1'
  spec.add_development_dependency 'database_cleaner', '~> 1.4', '> 1.4.0'
  spec.add_development_dependency 'mutant', '~> 0.7', '>= 0.7.9'
  spec.add_development_dependency 'mutant-rspec', '~> 0.7', '>= 0.7.9'
  spec.add_development_dependency 'guard-rspec', '~> 4.5', '>= 4.5.1'
  spec.add_development_dependency 'simplecov', '~> 0.10', '>= 0.10.0'
end
