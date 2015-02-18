require 'spec_helper'

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
      subject { -> { Team.sync } }

      it { is_expected.to change { Team.count }.by(2) }
      it { is_expected.to change { Player.count }.by(4) }

      it { is_expected.to change { Synchronisable::Import.count }.by(6) }
    end

    describe 'restrict sync to specific record(s)' do
      context 'when remote id is specified' do
        context "when local record doesn't exist" do
          subject { -> { Team.sync('team_0') } }

          it { is_expected.to change { Team.count }.by(1) }
          it { is_expected.to change { Synchronisable::Import.count }.by(3) }
        end

        context 'when local record exists' do
          include_context 'team_0 import'

          subject do
            -> {
              Team.sync('team_0')
              team_0.reload
            }
          end

          it { is_expected.not_to change { Team.count } }

          it { is_expected.to change { Player.count }.by(2) }
          it { is_expected.to change { Synchronisable::Import.count }.by(2) }

          it { is_expected.to change { team_0.name    } }
          it { is_expected.to change { team_0.country } }
          it { is_expected.to change { team_0.city    } }
        end
      end

      context 'when there are 2 imports with corresponding local records' do
        include_context 'team imports'

        context 'when local id is specified' do
          subject do
            -> {
              Team.sync(team_0.id)
              team_0.reload
            }
          end

          it { is_expected.not_to change { Team.count } }

          it { is_expected.to change { Player.count }.by(2) }
          it { is_expected.to change { Synchronisable::Import.count }.by(2) }

          it { is_expected.to change { team_0.name    } }
          it { is_expected.to change { team_0.country } }
          it { is_expected.to change { team_0.city    } }
        end

        context 'when array of local ids is specified' do
          subject do
            -> {
              Team.sync([team_0.id, team_1.id])
              [team_0, team_1].each(&:reload)
            }
          end

          it { is_expected.not_to change { Team.count } }

          it { is_expected.to change { Player.count }.by(4) }
          it { is_expected.to change { Synchronisable::Import.count }.by(4) }

          it { is_expected.to change { team_0.name    } }
          it { is_expected.to change { team_0.country } }
          it { is_expected.to change { team_0.city    } }

          it { is_expected.to change { team_1.name    } }
          it { is_expected.to change { team_1.country } }
          it { is_expected.to change { team_1.city    } }
        end

        context 'when array of remote ids is specified' do
          subject do
            -> {
              Team.sync([import_0.remote_id, import_1.remote_id])
              [team_0, team_1].each(&:reload)
            }
          end
        end
      end
    end

    context 'when remote id is not specified in attributes hash' do
      it 'return synchronization result that contains 1 error' do
        result = Team.sync([remote_attrs.last])
        expect(result.errors.count).to eq(1)
      end
    end

    context 'when local record does not exist' do
      subject { -> { Team.sync(remote_attrs.take(2)) } }

      it { is_expected.to change { Team.count }.by(2) }
      it { is_expected.to change { Synchronisable::Import.count }.by(2) }
    end

    context 'when local and import records exists' do
      let!(:import) do
        create(:import,
          :remote_id => 'team1',
          :synchronisable => create(:team,
            :name => 'x',
            :country => 'Russia',
            :city => 'Moscow',
          )
        )
      end

      let!(:team) { import.synchronisable }

      subject do
        -> {
          Team.sync(remote_attrs.take(2))
          team.reload
        }
      end

      it { is_expected.to change { Team.count }.by(1) }
      it { is_expected.to change { Synchronisable::Import.count }.by(1) }

      it { is_expected.to change { team.name    }.from('x').to('y') }
      it { is_expected.to change { team.country }.from('Russia').to('USA') }
      it { is_expected.to change { team.city    }.from('Moscow').to('Washington') }
    end
  end
end
