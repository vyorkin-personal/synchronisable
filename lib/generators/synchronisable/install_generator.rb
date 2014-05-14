require 'rails/generators'
require 'rails/generators/migration'
require 'rails/generators/active_record'

module Synchronisable
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)
    desc 'Generates (but does not run) a migration to add an imports table.'

    def create_migration_file
      migration_template 'create_imports_migration.rb', 'db/migrate/create_imports.rb'
    end

    def create_initializer_file
      copy_file 'initializer.rb', 'config/initializers/synchronisable.rb'
    end

    def self.next_migration_number(dirname)
      ActiveRecord::Generators::Base.next_migration_number(dirname)
    end
  end
end
