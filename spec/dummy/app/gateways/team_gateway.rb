class TeamGateway
  class << self
    @source = [FactoryGirl.build_pair(:team)]

    def fetch
      @source
    end

    def find(id)
      @source.find { |h| h[:maet_id] == id }
    end
  end
end
