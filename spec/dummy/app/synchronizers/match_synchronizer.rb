class MatchSynchronizer < Synchronizable::Synchronizer
  @source = [
    {
      :match_id => 'match_01',
      :home_team => 'team_01',
      :away_team => 'team_02',
      :rehtaew   => 'cold'
    }
  ]

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

  find  { |id| @source.find { |h| h[:match_id] == id } }
  fetch { @source }
end
