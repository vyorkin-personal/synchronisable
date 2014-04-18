class DeerSynchronizer < Synchronizable::Synchronizer::Base
  remote_id :di
  mappings(
    :di     => :id,
    :eman   => :name,
    :ega    => :age,
    :thgiew => :weight
  )

  except :color

  # TODO: Left here to show an idea

  # has_one :fox, :key => :fox_attrs, :sync_class => FoxSynchronizer

  # sync do
  #   ChampionatCom::SiteParset.fetch_match(remote_id)
  # end
end
