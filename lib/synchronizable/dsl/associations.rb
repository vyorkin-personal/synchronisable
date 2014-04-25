module Synchronizable
  module DSL
    module Associations
      extend ActiveSupport::Concern

      included do
        # storage for has_one/has_many associations.
        class_attribute :associations
        self.associations = {}
      end

      module ClassMethods
        %w(one many).each do |suffix|
          define_method(:"has_#{suffix}") do |model, opts = {}|
            model_name = model.to_s.demodulize.underscore
            setup_options(model_name, opts)
            associations[model_name.to_sym] = opts
          end
        end

        private

        def setup_options(model, opts)
          opts[:model] = model.classify.constantize

          if opts[:key].blank?
            suffix = singular?(model) ? 's' : ''
            opts[:key] = "#{model}_id#{suffix}"
          end
        end

        def singular?(word)
          word.pluralize != word &&
          word.singularize == word
        end
      end
    end
  end
end
