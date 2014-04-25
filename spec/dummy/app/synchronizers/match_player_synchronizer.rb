class MatchPlayerSynchronizer
  include Synchronizable::Synchronizer

  destroy_missed true
  mappings(
    :ref       => :ref_type,
    :formation => :formation_index,
    :match     => :match_id,
    :player    => :player_id
  )
end
