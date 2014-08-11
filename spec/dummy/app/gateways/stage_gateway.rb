class StageGateway < GatewayBase
  def source
    @source ||= [
      FactoryGirl.build(:remote_stage,
        :stage_id    => 'stage_0',
        :matches_ids => %w(match_0)
      ),
      FactoryGirl.build( :remote_stage,
        :stage_id    => 'stage_1',
        :matches_ids => %w(match_0)
      )
    ]
  end

  def fetch(params)
    tournament_id = params[:tournament_id]

    raise "missed parameter 'tournament_id'" unless tournament_id

    source.select do |attrs|
      attrs[:tour_id] = tournament_id
    end
  end

  def find(params)
    tournament_id, id = params[:tournament_id], params[:id]

    raise "missed parameter 'tournament_id'" unless tournament_id
    raise "missed parameter 'id'" unless id

    source.find do |attrs|
      attrs[:tour_id] = tournament_id &&
      attrs[:stage_id] = id
    end
  end
end
