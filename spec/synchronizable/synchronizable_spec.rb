require 'spec_helper'

describe Synchronizable do
  describe 'synchronization' do
    subject do
      -> { Synchronizable.sync }
    end

    context 'when all models specified' do
      before do
        Synchronizable.models = %w(Team Match MatchPlayer Player)
      end

      it { should change { Match.count }.by(1) }
      it { should change { Team.count }.by(2) }
      it { should change { MatchPlayer.count }.by(4) }
      it { should change { Player.count }.by(4) }

      it { should change { Synchronizable::Import.count }.by(11) }
    end
  end

  context 'when only Team and Match models specified' do
    subject do
      -> { Synchronizable.sync }
    end

    before do
      Synchronizable.models = %w(Team Match)
    end

    it { should change { Match.count }.by(1) }
    it { should change { Team.count }.by(2) }
    it { should change { Synchronizable::Import.count }.by(3) }

    context 'when models setting is overriden in method call' do
      it { should change { Match.count }.by(1) }
      it { should_not change { Team.count }.by(2) }
      it { should change { Synchronizable::Import.count }.by(1) }
    end
  end
end
