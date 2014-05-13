class MatchGateway < GatewayBase
  def id_key
    :match_id
  end

  def source
    @source ||= [
      FactoryGirl.build(:remote_match,
        :match_id  => 'match_0',
        :home_team => 'team_0',
        :away_team => 'team_1'
      )
    ]
  end
end
