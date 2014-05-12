require 'spec_helper'
require 'pry-byebug'

describe Match do
  describe 'synchronization' do
    context 'when has associations defined in Synchronizer' do
      subject do
        -> { Match.sync }
      end

      it { should change { Match.count }.by(1) }
      it { should change { Team.count }.by(2) }
      it { should change { MatchPlayer.count }.by(4) }

      it { should change { Synchronizable::Import.count }.by(7) }
    end

    # TODO: Left here until :include option is implemented
    #
    # context 'when associations specified with :include option' do
    #   subject do
    #     -> { sync_match }
    #   end

    #   def sync_match
    #     Match.sync(:include => {
    #       :match => {
    #         :team => :players
    #       }
    #     })
    #   end

    #   it { should change { Match.count }.by(1) }
    #   it { should change { Team.count }.by(2) }
    #   it { should change { Player.count }.by(22) }
    #   it { should change { MatchPlayer.count }.by(22) }

    #   it { should change { Synchronizable::Import.count }.by(47) }
    # end
  end
end
