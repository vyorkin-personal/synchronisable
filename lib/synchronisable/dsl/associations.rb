require 'synchronisable/dsl/association'

module Synchronisable
  module DSL
    module Associations
      extend ActiveSupport::Concern

      included do
        class_attribute :associations
        self.associations = {}
      end

      module ClassMethods
        def inherited(subclass)
          super
          subclass.associations = {}
        end

        %i(has_one has_many belongs_to).each do |kind|
          define_method(kind) do |name, options = {}|
            Association.create(self, kind, name, options)
          end
        end

        # Builds hash with association as key and array of ids as value.
        #
        # @param attrs [Hash] local record attributes
        #
        # @return [Hash<Synchronisable::Association, Array>] associations hash
        #
        # @raise [MissedAssocationsError] raised when the given
        #   attributes hash doesn't required associations
        def associations_for(attrs)
          ensure_required_associations(attrs)

          intersection = self.associations.map { |key, _| key } & attrs.keys
          Hash[intersection.map { |key| [self.associations[key], [*attrs[key]]] }]
        end

        private

        def ensure_required_associations(attrs)
          missing = required_associations - attrs.keys
          if missing.present?
            raise MissedAssociationsError, I18n.t(
              'errors.missed_associations',
              keys: missing, attrs: attrs
            )
          end
        end

        def required_associations
          self.associations.select { |_, a| a.required }.keys
        end
      end
    end
  end
end
