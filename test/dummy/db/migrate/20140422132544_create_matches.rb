class CreateMatches < ActiveRecord::Migration
  def change
    create_table :matches do |t|
      t.integer :beginning
      t.integer :home_team_id
      t.integer :away_team_id
      t.string :weather

      t.timestamps
    end
  end
end
