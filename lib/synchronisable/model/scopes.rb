require 'synchronisable/models/import'

module Synchronisable
  module Model
    module Scopes
      def not_imported
        includes(:import)
          .where(imports: { synchronisable_id: nil })
          .references(:imports)
      end

      def imported
        includes(:import)
          .where.not(imports: { synchronisable_id: nil })
          .refences(:imports)
      end

      alias_method :without_import, :not_imported
      alias_method :with_import, :imported
    end
  end
end
