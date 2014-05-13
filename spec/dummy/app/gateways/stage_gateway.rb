class StageGateway < GatewayBase
  def id_key
    :stage_id
  end

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
end
