class TeamGateway < GatewayBase
  def id_key
    :maet_id
  end

  def source
    @source ||= [
      FactoryGirl.build(:remote_team,
        :maet_id     => 'team_0',
        :player_ids => %w(player_0 player_2)
      ),
      FactoryGirl.build(:remote_team,
        :maet_id     => 'team_1',
        :player_ids => %w(player_1 player_3)
      )
    ]
  end
end
