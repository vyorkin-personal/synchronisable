require 'synchronisable/dsl/macro'

module Synchronisable
  module DSL
    # Association builder.
    # Subclasses must implement #macro method.
    class Association
      include Synchronisable::DSL::Macro

      KIND_KEY_SUFFIX_MAP = {
        :belongs_to => :id,
        :has_one => :id,
        :has_many => :ids
      }

      class << self
        attr_accessor :valid_options

        def create(synchronizer, kind, name, options)
          new(synchronizer, kind, name).create(options)
        end
      end

      self.valid_options = %i(key class_name required force_sync)

      attr_reader :kind, :name, :model, :key,
        :required, :force_sync

      def initialize(synchronizer, kind, name)
        @synchronizer, @kind, @name = synchronizer, kind, name.to_sym
        @key_suffix = KIND_KEY_SUFFIX_MAP[kind]
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

      def model_name
        @model.to_s.demodulize.underscore.to_sym
      end

      protected

      def set_defaults
        @required ||= false
        @force_sync ||= false

        @model ||= @name.to_s.singularize.classify.constantize
        @key = "#{@name.singularize}_#{@key_suffix}" unless @key.present?
      end

      private

      def validate_options(options)
        options.assert_valid_keys(Association.valid_options)
      end
    end
  end
end
