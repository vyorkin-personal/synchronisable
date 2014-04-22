class MatchPlayerSynchronizer < Synchronizable::Synchronizer::Base
  destroy_missed false
  mappings(
    :ref       => :ref_type,
    :formation => :formation_index,
    :match     => :match_id,
    :player    => :player_id
  )
end
