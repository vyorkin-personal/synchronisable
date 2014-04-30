require 'spec_helper'
require 'pry-byebug'

describe Match do
  describe 'synchronization' do
    context 'when has associations' do
      subject do
        -> { Match.sync }
      end

      it { should change { Match.count }.by(1) }
      it { should change { Team.count  }.by(2) }
      it { should change { Synchronizable::Import.count }.by(3) }
    end

    context 'when associations specified with :include option' do
      subject do
        Match.sync(:include => {
          :match => {
            :match_players => :player
          }
        })
      end

      it { should change { Match.count }.by(1) }
      # it { should change
    end
  end
end
