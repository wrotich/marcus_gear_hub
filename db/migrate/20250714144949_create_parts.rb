class CreateParts < ActiveRecord::Migration[8.0]
  def change
    create_table :parts do |t|
      t.string :name, null: false
      t.string :part_type, null: false
      t.text :description
      t.timestamps
    end

    add_index :parts, :part_type
    add_index :parts, [ :part_type, :name ]
  end
end
