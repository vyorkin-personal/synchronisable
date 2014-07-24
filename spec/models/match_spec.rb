require 'spec_helper'

describe Match do
  describe 'synchronization' do
    context 'when has associations defined in Synchronizer' do
      subject do
        -> { Match.sync }
      end

      it { is_expected.to change { Match.count }.by(1) }
      it { is_expected.to change { Team.count }.by(2) }
      it { is_expected.to change { Player.count }.by(4) }
      it { is_expected.to change { MatchPlayer.count }.by(4) }

      it { is_expected.to change { Synchronisable::Import.count }.by(11) }
    end

    context 'when associations specified with :includes option' do
      subject do
        -> { sync_match }
      end

      def sync_match
        Match.sync(:includes => {
          :team => :players,
          :blha => {
            :x => :z,
            :y => :f
          }
        })
      end

      it { is_expected.to change { Match.count }.by(1) }
      it { is_expected.to change { Team.count }.by(2) }
      it { is_expected.to change { Player.count }.by(4) }

      it { is_expected.to change { Synchronisable::Import.count }.by(7) }
    end
  end
end
