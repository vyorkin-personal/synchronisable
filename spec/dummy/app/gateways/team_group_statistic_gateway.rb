class TeamGroupStatisticGateway < GatewayBase
  def id_key
    :id
  end

  def find(id)
    raise NotImplementedError, 'Life is a bitch'
  end

  def source
    @source ||= [
      FactoryGirl.build(:remote_team_group_statistic,
        :id       => 'team_0',
        :team_id  => 'team_0'
      ),
      FactoryGirl.build(:remote_team_group_statistic,
        :id       => 'team_1',
        :team_id  => 'team_1'
      ),
    ]
  end
end
