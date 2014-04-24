class Team < ActiveRecord::Base
  synchronizable BreakConventionTeamSynchronizer
end
