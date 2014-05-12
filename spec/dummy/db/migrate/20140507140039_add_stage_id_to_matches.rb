class AddStageIdToMatches < ActiveRecord::Migration
  def change
    add_column :matches, :stage_id, :integer
    add_index :matches, :stage_id
  end
end
