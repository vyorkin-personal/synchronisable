require 'pry-byebug'

class MatchSynchronizer < Synchronizable::Synchronizer
  @gateway = MatchGateway.new

  has_one :team, key: 'home_team_id'
  has_one :team, key: 'away_team_id'

  has_many :players

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
    binding.pry
    attrs = source.remote_attrs

    MatchPlayer::REF_TYPES.each do |ref_type|
      match = source.local_record
      remote_player_ids = attrs[ref_type.to_sym] || {}

      player_imports = Synchronizable::Import
        .with_synchronizable_type(Player)
        .with_remote_ids(remote_player_ids)

      local_player_ids = player_imports.map do |import|
        import.synchronizable.id
      end

      local_player_ids.each do |player_id|
        match_player = MatchPlayer.find_by(
          :match_id  => match.id,
          :player_id => player_id
        )

        unless match_player
          MatchPlayer.create!({
            :ref_type  => ref_type,
            :match_id  => match.id,
            :player_id => player_id
          })
        end
      end
    end
  end
end
