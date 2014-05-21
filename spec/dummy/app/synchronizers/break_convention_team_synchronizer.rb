class BreakConventionTeamSynchronizer < Synchronisable::Synchronizer
  has_many :players

  remote_id :maet_id
  mappings(
    :eman    => :name,
    :yrtnuoc => :country,
    :ytic    => :city
  )
  except :ignored_1, :ignored_2

  gateway TeamGateway
end
