require 'spec_helper'

describe Stage do
  describe 'synchronization' do
    let!(:remote_attrs) do
      [
        build(:remote_stage, tour_id: '1', eman: 'ignored'),
        build(:remote_stage, tour_id: '2'),
        build(:remote_stage, tour_id: '3')
      ]
    end

    describe 'skipping with before_sync hook' do
      subject { -> { Stage.sync(remote_attrs, :includes => {}) } }

      it { is_expected.to change { Stage.count }.by(2) }
      it { is_expected.to change { Synchronisable::Import.count }.by(2) }
    end
  end
end
