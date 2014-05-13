require 'spec_helper'
require 'pry-byebug'

describe Synchronizable do
  describe 'synchronization' do
    subject do
      -> {
        # binding.pry
        Synchronizable.sync
      }
    end

    describe 'models specified in configuration' do
      context 'only Team and Match' do
        before :all do
          Synchronizable.models = %w(Match Team)
        end

        it { should change { Match.count }.by(1) }
        it { should change { Team.count }.by(2) }
        it { should change { Player.count }.by(4) }
        it { should change { MatchPlayer.count }.by(4) }

        it { should change { Synchronizable::Import.count }.by(11) }
      end

      context 'all' do
        before :all do
          Synchronizable.models = %w(
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

        it { should change { Synchronizable::Import.count }.by(14) }
      end

      # TODO: Left here until :include option is implemented
      #
      # context 'when models setting is overriden in method call' do
      #   before :all do
      #     Synchronizable.models = %w(Team Match)
      #   end

      #   subject do
      #     -> { Synchronizable.sync(Match, Player) }
      #   end

      #   it { should change { Match.count }.by(1) }
      #   it { should change { Player.count }.by(22) }
      #   it { should_not change { Team.count }.by(2) }

      #   it { should change { Synchronizable::Import.count }.by(5) }
      # end
    end
  end
end
