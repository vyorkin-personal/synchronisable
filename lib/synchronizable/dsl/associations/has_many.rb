require 'synchronizable/dsl/associations/association'

module Synchronizable
  module DSL
    module Associations
      class HasMany < Association
        key_suffix 'ids'
      end
    end
  end
end
