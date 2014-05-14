require 'spec_helper'

describe Synchronisable::Import do
  let!(:team) { create :team }
  subject     { create(:import, synchronisable: team) }

  it 'destroys itself with synchronisable record' do
    expect { subject.destroy_with_synchronisable }.to change(Team, :count).by(-1)
  end
end
