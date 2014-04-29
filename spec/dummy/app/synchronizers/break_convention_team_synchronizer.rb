class BreakConventionTeamSynchronizer < Synchronizable::Synchronizer
  remote_id :maet_id
  mappings(
    :eman    => :name,
    :yrtnuoc => :country,
    :ytic    => :city
  )
  except :ignored_1, :ignored_2

  gateway TeamGateway

  fetch do |value|
    [*value].map { |id| gateway.find(id) }
  end
end
