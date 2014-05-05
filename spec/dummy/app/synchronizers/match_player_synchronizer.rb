class MatchPlayerSynchronizer < Synchronizable::Synchronizer
  destroy_missed true
  mappings(
    :ref       => :ref_type,
    :formation => :formation_index,
    :match     => :match_id,
    :player    => :player_id
  )

  find  { |id| MatchPlayerGateway.find(id) }
  fetch { MatchPlayerGateway.fetch }
end
