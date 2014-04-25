class Match < ActiveRecord::Base
  belongs_to :home_team, class_name: 'Team'
  belongs_to :away_team, class_name: 'Team'

  has_many :match_players, dependent: :destroy

  synchronizable
end
