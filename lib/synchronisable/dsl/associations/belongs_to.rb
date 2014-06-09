require 'synchronisable/dsl/associations/association'

module Synchronisable
  module DSL
    module Associations
      # `belongs_to` association builder.
      class BelongsTo < Association
        key_suffix 'id'

        def macro
          :belongs_to
        end
      end
    end
  end
end
