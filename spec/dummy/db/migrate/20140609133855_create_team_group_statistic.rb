class CreateTeamGroupStatistic < ActiveRecord::Migration
  def change
    create_table :team_group_statistics do |t|
      t.references :team, index: true
      t.integer :games_played
      t.integer :games_won
      t.integer :games_lost
      t.integer :games_draw

      t.timestamps
    end
  end
end
