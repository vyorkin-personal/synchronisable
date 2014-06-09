require 'synchronisable/dsl/associations/association'

module Synchronisable
  module DSL
    module Associations
      # `has_many` association builder.
      class HasMany < Association
        key_suffix 'ids'

        def macro
          :has_many
        end
      end
    end
  end
end
