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

        it { should change { Match.count }.by(1) }
        it { should change { Team.count }.by(2) }
        it { should change { Player.count }.by(4) }
        it { should change { MatchPlayer.count }.by(4) }

        it { should change { Synchronisable::Import.count }.by(11) }
      end

      context 'all' do
        before :all do
          Synchronisable.models = %w(
            Stage Tournament Team
            Match MatchPlayer Player
          )
        end

        it { should change { Tournament.count }.by(1) }
        it { should change { Stage.count }.by(2) }
        it { should change { Match.count }.by(1) }
        it { should change { Team.count }.by(2) }
        it { should change { MatchPlayer.count }.by(4) }
        it { should change { Player.count }.by(4) }

        it { should change { Synchronisable::Import.count }.by(14) }
      end

      # TODO: Left here until :include option is implemented
      #
      # context 'when models setting is overriden in method call' do
      #   before :all do
      #     Synchronisable.models = %w(Team Match)
      #   end

      #   subject do
      #     -> { Synchronisable.sync(Match, Player) }
      #   end

      #   it { should change { Match.count }.by(1) }
      #   it { should change { Player.count }.by(22) }
      #   it { should_not change { Team.count }.by(2) }

      #   it { should change { Synchronisable::Import.count }.by(5) }
      # end
    end
  end
end
