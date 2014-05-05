require 'synchronizable/dsl/associations/association'

module Synchronizable
  module DSL
    module Associations
      # `has_many` association builder.
      class HasMany < Association
        key_suffix 'ids'
      end
    end
  end
end
