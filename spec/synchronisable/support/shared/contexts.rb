shared_context 'team_0 import' do
  let!(:import_0) do
    create(:import,
      :remote_id => 'team_0',
      :synchronisable => create(:team,
        :name => 'x',
        :country => 'Russia',
        :city => 'Moscow',
      )
    )
  end
  let!(:team_0) { import_0.synchronisable }
end

shared_context 'team_1 import' do
  let!(:import_1) do
    create(:import,
      :remote_id => 'team_1',
      :synchronisable => create(:team,
        :name => 'y',
        :country => 'France',
        :city => 'Paris',
      )
    )
  end
  let!(:team_1) { import_1.synchronisable }
end

shared_context 'team imports' do
  include_context 'team_0 import'
  include_context 'team_1 import'
end

