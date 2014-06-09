class TeamGroupStatisticSynchronizer < Synchronisable::Synchronizer
  belongs_to :team

  gateway TeamGroupStatisticGateway
end
