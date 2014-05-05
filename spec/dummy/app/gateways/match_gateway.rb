class MatchGateway
  class << self
    @source = [FactoryGirl.build(:remote_match)]

    def fetch
      @source
    end

    def find(id)
      @source.find { |h| h[:match_id] == id }
    end
  end
end
