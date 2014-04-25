module Synchronizable
  # Synchronization context.
  #
  # @api private
  class Context
    Result = Struct.new(:before, :after, :deleted)

    attr_reader :result
    attr_accessor :model, :errors

    def initialize(model)
      @model  = model
      @errors = []
      @result = Result.new(0, 0, 0)
    end

    # String with summary synchronization info.
    def summary_message
      I18n.t('messages.result',
        :model   => model,
        :before  => result.before,
        :after   => result.after,
        :deleted => result.deleted,
        :errors  => errors.count
      )
    end
  end
end
