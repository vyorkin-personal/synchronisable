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
      let!(:context) { Stage.sync(remote_attrs, :includes => {}) }

      it 'skips hashes where name is "ignored"' do
        expect(Stage.count).to eq(2)
        expect(Synchronisable::Import.count).to eq(2)
      end
    end
  end
end
