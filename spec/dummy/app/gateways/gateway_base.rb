require 'synchronisable/gateway'

class GatewayBase < Synchronisable::Gateway
  def id_key
    not_implemented! :id_key
  end

  def source
    not_implemented! :source
  end

  def fetch(params)
    source
  end

  def find(id)
    source.find { |h| h[id_key] == id }
  end
end
