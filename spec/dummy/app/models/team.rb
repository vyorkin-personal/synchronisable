class Team < ActiveRecord::Base
  has_many :players

  synchronisable BreakConventionTeamSynchronizer
end
