class PlayerGateway < GatewayBase
  def id_key
    :player_id
  end

  def source
    @source ||= [
      FactoryGirl.build(:remote_player,
        :team      => 'team_0',
        :player_id => 'player_0'
      ),
      FactoryGirl.build(:remote_player,
        :team      => 'team_0',
        :player_id => 'player_2'
      ),
      FactoryGirl.build(:remote_player,
        :team      => 'team_1',
        :player_id => 'player_1'
      ),
      FactoryGirl.build(:remote_player,
        :team      => 'team_1',
        :player_id => 'player_3'
      )
    ]
  end
end
