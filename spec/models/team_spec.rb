require 'spec_helper'

require 'pry-byebug'

describe Team do
  describe 'synchronization' do
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
        },
        {
          :eman      => 'a',
          :yrtnuoc   => 'blah',
          :ytic      => 'blah'
        }
      ]
    end

    context 'sync with no data specified' do
      subject do
        -> { Team.sync }
      end

      it { should change { Team.count }.by(2) }
      it { should change { Synchronizable::Import.count }.by(2) }
    end

    context 'when remote id is not specified' do
      subject { Team.sync([remote_attrs.last]) }

      its(:errors) { should have(1).items }
    end

    context 'when local record does not exist' do
      subject do
        -> { Team.sync(remote_attrs.take(2)) }
      end

      it { should change { Team.count }.by(2) }
      it { should change { Synchronizable::Import.count }.by(2) }
    end

    context 'when local and import records exists' do
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

      subject do
        -> {
          Team.sync(remote_attrs.take(2))
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
end
