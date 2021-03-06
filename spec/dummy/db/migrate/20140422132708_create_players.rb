class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.date :birthday
      t.string :citizenship
      t.float :height
      t.float :weight
      t.references :team, index: true

      t.timestamps
    end
  end
end
