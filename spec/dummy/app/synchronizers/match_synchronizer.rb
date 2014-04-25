class MatchSynchronizer
  include Synchronizable::Synchronizer

  destroy_missed true
  remote_id :match_id
  mappings(
    :gninnigeb => :beginning,
    :home_team => :home_team_id,
    :away_team => :away_team_id,
    :rehtaew   => :weather
  )
  except :ignored_1, :ignored_2
end
