class StageSynchronizer < Synchronizable::Synchronizer
  @gateway = StageGateway.new

  has_many :matches

  remote_id :stage_id

  mappings(
    :tour_id   => :tournament_id,
    :gninnigeb => :beginning,
    :gnidge    => :ending,
    :eman      => :name,
    :rebmun    => :number
  )

  except :ignored_1, :ignored_2

  find  { |id| @gateway.find(id) }
  fetch { @gateway.fetch }
end
