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

    #   it { is_expected.to change { Match.count }.by(1) }
    #   it { is_expected.to change { Team.count }.by(2) }
    #   it { is_expected.to change { Player.count }.by(22) }
    #   it { is_expected.to change { MatchPlayer.count }.by(22) }

    #   it { is_expected.to change { Synchronisable::Import.count }.by(47) }
    # end
  end
end
