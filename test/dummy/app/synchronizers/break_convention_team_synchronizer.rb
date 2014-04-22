class BreakConventionTeamSynchronizer < Synchronizable::Synchronizer::Base
  remote_id :maet_id
  mappings(
    :eman    => :name,
    :yrtnuoc => :country,
    :ytic    => :city
  )

  except :ignored_1, :ignored_2
end
