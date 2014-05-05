class MatchSynchronizer < Synchronizable::Synchronizer
  has_one :team, key: 'home_team_id'
  has_one :team, key: 'away_team_id'

  has_many :match_players, class_name: 'MatchPlayer'

  remote_id :match_id

  mappings(
    :gninnigeb => :beginning,
    :home_team => :home_team_id,
    :away_team => :away_team_id,
    :rehtaew   => :weather
  )
  except :ignored_1, :ignored_2
  destroy_missed true

  find  { |id| MatchGateway.find(id) }
  fetch { MatchGateway.fetch }
end
