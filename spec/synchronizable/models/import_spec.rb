require 'spec_helper'

describe Synchronizable::Import do
  let!(:team) { create :team }
  subject     { create(:import, synchronizable: team) }

  it 'destroys itself with synchronizable record' do
    expect { subject.destroy_with_synchronizable }.to change(Team, :count).by(-1)
  end
end
