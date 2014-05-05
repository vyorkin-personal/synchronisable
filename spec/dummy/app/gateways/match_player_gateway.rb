class MatchPlayerGateway
  class << self
    @source =
      FactoryGirl.build_list(:remote_match_player, 11, match: 'match_0') +
      FactoryGirl.build_list(:remote_match_player, 11, match: 'match_1')

    def fetch
      @source
    end

    def find(id)
      @source.find { |h| h[:match_id] == id }
    end
  end
end
