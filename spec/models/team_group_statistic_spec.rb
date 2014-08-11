require 'spec_helper'

describe TeamGroupStatistic do
  describe 'synchronization' do
    context 'sync with no data specified' do
      subject { -> { TeamGroupStatistic.sync } }

      it { is_expected.to change { TeamGroupStatistic.count }.by(2) }
      it { is_expected.to change { Team.count }.by(2) }
      it { is_expected.to change { Player.count }.by(4) }

      it { is_expected.to change { Synchronisable::Import.count }.by(8) }
    end
  end
end
