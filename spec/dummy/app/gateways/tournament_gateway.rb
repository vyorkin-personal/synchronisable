class TournamentGateway < GatewayBase
  def id_key
    :tour_id
  end

  def source
    @source ||= [
      FactoryGirl.build(:remote_tournament,
        :tour_id => 'tournament_0',
        :is_current => true,
        :stages_ids => %w(stage_0 stage_1)
      )
    ]
  end
end
