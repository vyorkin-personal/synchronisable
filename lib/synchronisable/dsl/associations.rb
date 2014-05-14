require 'synchronisable/dsl/associations/has_one'
require 'synchronisable/dsl/associations/has_many'

module Synchronisable
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

          Hash[intersection.map { |key|
            [self.associations[key], [*attrs[key].dup]]
          }]
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
          self.associations.select { |_, a| a.required }.map(&:key)
        end
      end
    end
  end
end
