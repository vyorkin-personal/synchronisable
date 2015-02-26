module Synchronisable
  # Synchronization context.
  class Context
    attr_accessor :model, :errors,
                  :before, :after, :deleted

    def initialize(model, parent)
      @model, @parent = model, parent
      @errors = []
      @before, @after, @deleted = 0, 0, 0
    end

    def success?
      errors.empty?
    end

    # @return [String] summary synchronization info
    def summary_message
      msg = I18n.t('messages.result',
        :model   => model,
        :parent  => @parent.try(:model) || 'nil',
        :before  => before,
        :after   => after,
        :deleted => deleted,
        :errors  => errors.count
      )

      msg << I18n.t('messages.errors', errors: errors.join('. ')) if errors.any?
      msg
    end
  end
end
