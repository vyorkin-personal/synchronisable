require 'spec_helper'

describe Synchronisable do
  describe 'synchronization' do
    subject do
      -> { Synchronisable.sync }
    end

    describe 'models specified in configuration' do
      context 'only Team and Match' do
        before :all do
          Synchronisable.models = %w(Match Team)
        end

        it { is_expected.to change { Match.count }.by(1) }
        it { is_expected.to change { Team.count }.by(2) }
        it { is_expected.to change { Player.count }.by(4) }
        it { is_expected.to change { MatchPlayer.count }.by(4) }

        it { is_expected.to change { Synchronisable::Import.count }.by(11) }
      end

      context 'all' do
        before :all do
          Synchronisable.models = %w(
            Tournament Team
            Match MatchPlayer Player
          )
        end

        it { is_expected.to change { Tournament.count }.by(1) }
        it { is_expected.to change { Stage.count }.by(2) }
        it { is_expected.to change { Match.count }.by(1) }
        it { is_expected.to change { Team.count }.by(2) }
        it { is_expected.to change { MatchPlayer.count }.by(4) }
        it { is_expected.to change { Player.count }.by(4) }

        it { is_expected.to change { Synchronisable::Import.count }.by(14) }
      end

      context 'when models setting is overriden in method call' do
        before :all do
          Synchronisable.models = %w(Team Match)
        end

        subject do
          -> { Synchronisable.sync(Match, Player) }
        end

        it { is_expected.to change { Match.count }.by(1) }
        it { is_expected.to change { Team.count }.by(2) }
        it { is_expected.to change { Player.count }.by(4) }
        it { is_expected.to change { MatchPlayer.count }.by(4) }

        it { is_expected.not_to change { Stage.count } }
        it { is_expected.not_to change { Tournament.count } }

        it { is_expected.to change { Synchronisable::Import.count }.by(11) }
      end
    end
  end
end
