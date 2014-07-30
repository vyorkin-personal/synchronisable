require 'spec_helper'

describe Tournament do
  describe 'synchronization' do
    let!(:remote_attrs) do
      [
        build(:remote_tournament, tour_id: '1', eman: 'tour-1'),
        build(:remote_tournament, tour_id: '2', eman: 'tour-1'),
        build(:remote_tournament, tour_id: '3', eman: 'tour-2')
      ]
    end

    subject { -> { Tournament.sync(remote_attrs) } }

    it { is_expected.to change { Tournament.count }.by(2) }
    it { is_expected.to change { Synchronisable::Import.count }.by(2) }
  end
end
