class BreakConventionTeamSynchronizer < Synchronisable::Synchronizer
  @gateway = TeamGateway.new

  remote_id :maet_id
  mappings(
    :eman    => :name,
    :yrtnuoc => :country,
    :ytic    => :city
  )
  except :ignored_1, :ignored_2

  find  { |id| @gateway.find(id) }
  fetch { @gateway.fetch }
end
