class CreateMatchPlayers < ActiveRecord::Migration
  def change
    create_table :match_players do |t|
      t.references :match, index: true
      t.references :player, index: true
      t.string :ref_type
      t.integer :formation_index

      t.timestamps
    end
  end
end
