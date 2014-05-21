module Synchronisable
  class Gateway
    attr_reader :synchronizer

    def initialize(synchronizer)
      @synchronizer = synchronizer
    end

    def fetch
      not_implemented :fetch
    end

    def find(id)
      not_implemented :find
    end

    protected

    def not_implemented(method)
      raise NotImplementedError,
        I18n.t('errors.gateway_method_missing', method: method)
    end
  end
end
