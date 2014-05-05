class Team < ActiveRecord::Base
  has_many :players

  synchronizable BreakConventionTeamSynchronizer
end
