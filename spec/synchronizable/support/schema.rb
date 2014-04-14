ActiveRecord::Schema.define do
  self.verbose = false

  create_table :deers, force: true do |t|
    t.string  :name
    t.integer :age
    t.integer :weight

    t.timestamps
  end

  create_table :imports do |t|
    t.string :synchronizable_type
    t.integer :synchronizable_id
    t.text :attrs
    t.string :remote_id, null: false

    t.timestamps
  end

  add_index :imports, :remote_id
end
