module Synchronizable
  # Synchronization context.
  class Context
    attr_accessor :model, :errors,
                  :before, :after, :deleted

    def initialize(model, parent)
      @model, @parent  = model, parent
      @errors = []
      @before, @after, @deleted = 0, 0, 0
    end

    # @return [String] summary synchronization info.
    def summary_message
      I18n.t('messages.result',
        :model   => model,
        :parent  => parent,
        :before  => before,
        :after   => after,
        :deleted => deleted,
        :errors  => errors.count
      )
    end
  end
end
