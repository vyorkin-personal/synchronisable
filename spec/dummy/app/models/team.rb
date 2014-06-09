class Team < ActiveRecord::Base
  has_many :players
  has_one :team_group_statistic

  synchronisable BreakConventionTeamSynchronizer
end
