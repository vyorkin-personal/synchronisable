require 'synchronisable/dsl/associations/association'

module Synchronisable
  module DSL
    module Associations
      # `has_one` association builder.
      class HasOne < Association
        key_suffix 'id'
      end
    end
  end
end

