require 'synchronizable/dsl/associations/association'

module Synchronizable
  module DSL
    module Associations
      # `has_one` association builder.
      class HasOne < Association
        key_suffix 'id'
      end
    end
  end
end

