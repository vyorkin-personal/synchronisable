class TournamentSynchronizer < Synchronisable::Synchronizer
  has_many :stages

  remote_id :tour_id
  unique_id :name

  mappings(
    :eman       => :name,
    :eman_trohs => :short_name,
    :gninnigeb  => :beginning,
    :gnidge     => :ending,
    :tnerruc_si => :is_current
  )

  only :name, :beginning, :ending

  gateway TournamentGateway
end
