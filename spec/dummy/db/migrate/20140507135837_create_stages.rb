class CreateStages < ActiveRecord::Migration
  def change
    create_table :stages do |t|
      t.date :beginning
      t.date :ending
      t.references :tournament, index: true
      t.string :name
      t.integer :number

      t.timestamps
    end
  end
end
