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
  end
end
