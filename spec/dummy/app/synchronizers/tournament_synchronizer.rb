class TournamentSynchronizer < Synchronizable::Synchronizer
  @gateway = TournamentGateway.new

  has_many :stages

  remote_id :tour_id

  mappings(
    :eman       => :name,
    :eman_trohs => :short_name,
    :gninnigeb  => :beginning,
    :gnidge     => :ending,
    :tnerruc_si => :is_current
  )

  only :name, :beginning, :ending

  find  { |id| @gateway.find(id) }
  fetch { @gateway.fetch }
end
