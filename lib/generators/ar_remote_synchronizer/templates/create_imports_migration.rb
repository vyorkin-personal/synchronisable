class CreateImports < ActiveRecord::Migration
  def self.up
    create_table :imports do |t|
      t.string :local_type, null: false
      t.text :attrs
      t.integer :local_id, null: false
      t.string :remote_id, null: false

      t.timestamps
    end

    add_index :imports, :remote_id
  end

  def self.down
    remove_index :imports, :remote_id
    drop_table :imports
  end
end
