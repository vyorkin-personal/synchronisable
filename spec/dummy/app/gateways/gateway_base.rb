class GatewayBase
  def id_key
    raise NotImplementedError,
      I18n.t('errors.gateway_method_missing', method: 'id_key')
  end

  def source
    raise NotImplementedError,
      I18n.t('errors.gateway_method_missing', method: 'source')
  end

  def fetch
    source
  end

  def find(id)
    source.find { |h| h[id_key] == id }
  end
end
