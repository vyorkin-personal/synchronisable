require 'synchronisable/dsl/associations/association'

module Synchronisable
  module DSL
    module Associations
      # `belongs_to` association builder.
      class BelongsTo < Association
        key_suffix 'id'
      end
    end
  end
end
