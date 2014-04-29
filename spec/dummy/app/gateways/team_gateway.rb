class TeamGateway
  def initialize
    @source = [
      {
        :maet_id   => 'team_01',
        :eman      => 'foo',
        :yrtnuoc   => 'France',
        :ytic      => 'Paris',
        :ignored_2 => 'ignored'
      },
      {
        :maet_id   => 'team_02',
        :eman      => 'bar',
        :yrtnuoc   => 'Germany',
        :ytic      => 'Berlin',
        :ignored_1 => 'ignored',
        :ignored_2 => 'ignored'
      }
    ]
  end

  def find(id)
    source.find do |item|
      item[:maet_id] == id
    end
  end
end
