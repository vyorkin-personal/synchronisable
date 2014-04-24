class MatchPlayerSynchronizer < Synchronizable::Synchronizer::Base
  destroy_missed true
  mappings(
    :ref       => :ref_type,
    :formation => :formation_index,
    :match     => :match_id,
    :player    => :player_id
  )
end
