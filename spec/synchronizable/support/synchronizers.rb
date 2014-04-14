class DeerSynchronizer < Synchronizable::Synchronizer::Base
  configure :di, {
    :di     => :id,
    :eman   => :name,
    :ega    => :age,
    :thgiew => :weight
  }
end
