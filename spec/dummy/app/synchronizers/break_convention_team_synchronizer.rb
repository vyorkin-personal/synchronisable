class BreakConventionTeamSynchronizer < Synchronizable::Synchronizer
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

  remote_id :maet_id
  mappings(
    :eman    => :name,
    :yrtnuoc => :country,
    :ytic    => :city
  )
  except :ignored_1, :ignored_2

  find  { |id| @source.find { |h| h[:maet_id] == id } }
  fetch { @source }
end
