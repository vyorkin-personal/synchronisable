class BreakConventionTeamSynchronizer < Synchronizable::Synchronizer
  remote_id :maet_id
  mappings(
    :eman    => :name,
    :yrtnuoc => :country,
    :ytic    => :city
  )
  except :ignored_1, :ignored_2

  find  { |id| TeamGateway.find(id) }
  fetch { TeamGateway.fetch }
end
