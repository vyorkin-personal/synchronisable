require 'spec_helper'
require 'pry-byebug'

describe Synchronizable do
  describe 'synchronization' do
    subject do
      -> { Synchronizable.sync }
    end

    describe 'models specified in configuration' do
      context 'only Team and Match' do
        before :all do
          Synchronizable.models = %w(Team Match)
        end

        it { should change { Match.count }.by(1) }
        it { should change { Team.count }.by(2) }

        it { should change { Synchronizable::Import.count }.by(3) }
      end

      context 'all' do
        before :all do
          Synchronizable.models = %w(Team Match MatchPlayer Player)
        end

        it { should change { Match.count }.by(1) }
        it { should change { Team.count }.by(2) }
        it { should change { MatchPlayer.count }.by(4) }
        it { should change { Player.count }.by(4) }

        it { should change { Synchronizable::Import.count }.by(11) }
      end

      context 'when models setting is overriden in method call' do
        before :all do
          Synchronizable.models = %w(Team Match)
        end

        subject do
          -> { Synchronizable.sync(Match, Player) }
        end

        it { should change { Match.count }.by(1) }
        it { should change { Player.count }.by(4) }
        it { should_not change { Team.count }.by(2) }

        it { should change { Synchronizable::Import.count }.by(5) }
      end
    end
  end
end
