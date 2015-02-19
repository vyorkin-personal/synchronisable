class TournamentGateway < GatewayBase
  def id_key
    :tour_id
  end

  def source
    @source ||= [
      FactoryGirl.build(:remote_tournament,
        :tour_id => 'tournament_0',
        :is_current => true,
        :stage_ids => [
          {
            id: 'stage_0',
            tournament_id: 'tournament_0'
          },
          {
            id: 'stage_1',
            tournament_id: 'tournament_0'
          }
        ]
      )
    ]
  end
end
