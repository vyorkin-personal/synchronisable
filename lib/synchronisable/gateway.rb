module Synchronisable
  class Gateway
    def fetch(params = {})
      not_implemented! :fetch
    end

    def find(params)
      not_implemented! :find
    end

    protected

    def not_implemented!(method)
      raise NotImplementedError,
        I18n.t('errors.gateway_method_missing', method: method)
    end
  end
end
