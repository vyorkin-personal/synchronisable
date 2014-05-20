class MatchSynchronizer < Synchronisable::Synchronizer
  @gateway = MatchGateway.new

  has_one :team, key: 'home_team_id'
  has_one :team, key: 'away_team_id'

  remote_id :match_id

  mappings(
    :gninnigeb => :beginning,
    :home_team => :home_team_id,
    :away_team => :away_team_id,
    :rehtaew   => :weather,
    :ln_home   => :line_up_home,
    :ln_away   => :line_up_away,
    :sub_home  => :substitutes_home,
    :sub_away  => :substitutes_away
  )

  except :ignored_1, :ignored_2,
         :line_up_home, :line_up_away,
         :substitutes_home, :substitutes_away

  destroy_missed true

  find  { |id| @gateway.find(id) }
  fetch { @gateway.fetch }

  after_sync do |source|
    MatchPlayer::REF_TYPES.each do |ref_type|
      sync_match_players(source, ref_type)
    end
  end

  class << self
    def sync_match_players(source, ref_type)
      match = source.local_record
      remote_player_ids = source.remote_attrs[ref_type.to_sym] || {}

      player_imports = Synchronisable::Import
        .with_synchronisable_type(Player)
        .with_remote_ids(remote_player_ids)

      local_player_ids = player_imports.map do |import|
        import.synchronisable.id
      end

      local_player_ids.each do |player_id|
        sync_match_player({
          :match_id  => match.id,
          :player_id => player_id,
          :ref_type  => ref_type
        })
      end
    end

    def sync_match_player(attrs)
      match_player = MatchPlayer.find_by(attrs)
      unless match_player
        remote_id = "#{attrs[:match_id]}_#{attrs[:player_id]}"
        Synchronisable::Import.create!(
          :synchronisable => MatchPlayer.create!(attrs),
          :remote_id => remote_id,
          :attrs => attrs
        )
      end
    end
  end
end
