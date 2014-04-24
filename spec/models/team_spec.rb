require 'spec_helper'
require 'pry-byebug'

describe Team do
  let!(:import) do
    create(:import,
      :remote_id => 'team1',
      :synchronizable => create(:team,
        :name    => 'x',
        :country => 'Russia',
        :city    => 'Moscow',
      )
    )
  end

  let!(:team_x) { import.synchronizable }

  let!(:remote_attrs) do
    [
      {
        :maet_id   => 'team1',
        :eman      => 'y',
        :yrtnuoc   => 'USA',
        :ytic      => 'Washington',
        :ignored_1 => 'ignored',
        :ignored_2 => 'ignored'
      },
      {
        :maet_id   => 'team2',
        :eman      => 'z',
        :yrtnuoc   => 'France',
        :ytic      => 'Paris',
        :ignored_2 => 'ignored'
      }
    ]
  end

  describe 'synchronization' do
    subject do
      -> {
        Team.sync(remote_attrs)
        team_x.reload
      }
    end

    it { should change { Team.count }.by(1) }
    it { should change { Synchronizable::Import.count }.by(1) }

    it { should change { team_x.name    }.from('x').to('y') }
    it { should change { team_x.country }.from('Russia').to('USA') }
    it { should change { team_x.city    }.from('Moscow').to('Washington') }
  end
end
