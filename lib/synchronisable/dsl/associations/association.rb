require 'synchronisable/dsl/macro'

module Synchronisable
  module DSL
    module Associations
      # Association builder.
      # Subclasses must implement #macro method.
      class Association
        include Synchronisable::DSL::Macro

        attribute :key_suffix, default: -> { raise NotImplementedError }

        class << self
          attr_accessor :valid_options

          def create(synchronizer, name, options)
            new(synchronizer, name).create(options)
          end
        end

        self.valid_options = %i(key class_name required force_sync)

        attr_reader :name, :model, :key,
          :required, :force_sync

        def initialize(synchronizer, name)
          @synchronizer, @name = synchronizer, name.to_sym
        end

        def create(options)
          validate_options(options)

          @key = options[:key]
          @required = options[:required]
          @force_sync = options[:force_sync]

          if options[:class_name].present?
            @model = options[:class_name].constantize
          end

          set_defaults

          @synchronizer.associations[@key] = self
        end

        def macro
          raise NotImplementedError
        end

        def model_name
          @model.to_s.demodulize.underscore.to_sym
        end

        protected

        def set_defaults
          @required ||= false
          @force_sync ||= false

          @model ||= @name.to_s.classify.constantize
          @key = "#{@name}_#{self.class.key_suffix}" unless @key.present?
        end

        private

        def validate_options(options)
          options.assert_valid_keys(Association.valid_options)
        end
      end
    end
  end
end
