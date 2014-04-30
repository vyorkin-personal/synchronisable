require 'synchronizable/dsl/associations/has_one'
require 'synchronizable/dsl/associations/has_many'

module Synchronizable
  module DSL
    module Associations
      extend ActiveSupport::Concern

      included do
        class_attribute :associations
        self.associations = {}
      end

      module ClassMethods
        [HasOne, HasMany].each do |klass|
          macro = klass.to_s.demodulize.underscore.to_sym

          define_method(macro) do |name, options = {}|
            klass.create(self, name, options)
          end
        end

        def associations_for(keys)
          ensure_required_associations(keys)
          intersection = associations.map { |key, _| key } & keys
          Hash[intersection.map { |key| [key, associations[key]] }]
        end

        private

        def ensure_required_associations(keys)
          missing = required_associations - keys
          if missing.present?
            raise MissedAssociationsError, I18n.t(
              'errors.missed_associations',
              keys: missing, attrs: attrs
            )
          end
        end

        def required_associations
          associations.select { |_, a| a.required }.map(&:key)
        end
      end
    end
  end
end
