class PlayerGateway
  class << self
    @source =
      FactoryGirl.build_list(:remote_player, 11, team: 'team_0') +
      FactoryGirl.build_list(:remote_player, 11, team: 'team_1')

    def fetch
      @source
    end

    def find(id)
      @source.find { |h| h[:player_id] == id }
    end
  end
end
