require 'spec_helper'

describe Synchronizable::Import do
  let!(:deer) { create :deer }
  subject     { create(:import, synchronizable: deer) }

  it 'destroys itself with synchronizable record' do
    expect { subject.destroy_with_synchronizable }.to change(Deer, :count).by(-1)
  end
end
