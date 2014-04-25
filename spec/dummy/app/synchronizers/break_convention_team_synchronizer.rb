class BreakConventionTeamSynchronizer
  include Synchronizable::Synchronizer

  remote_id :maet_id
  mappings(
    :eman    => :name,
    :yrtnuoc => :country,
    :ytic    => :city
  )
  except :ignored_1, :ignored_2

  sync do
    [{
      :maet_id   => 'team_0',
      :eman      => 'z',
      :yrtnuoc   => 'France',
      :ytic      => 'Paris',
      :ignored_2 => 'ignored'
    }]
  end
end
