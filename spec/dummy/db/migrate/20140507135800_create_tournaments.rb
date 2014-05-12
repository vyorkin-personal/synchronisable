class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.string :short_name
      t.date :beginning
      t.date :ending
      t.boolean :is_current, default: false, null: false

      t.timestamps
    end
  end
end
