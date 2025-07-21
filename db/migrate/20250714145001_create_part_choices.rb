class CreatePartChoices < ActiveRecord::Migration[8.0]
  def change
    create_table :part_choices do |t|
      t.references :part, null: false, foreign_key: true
      t.string :name, null: false
      t.decimal :base_price, precision: 10, scale: 2, null: false, default: 0
      t.boolean :in_stock, default: true
      t.text :description
      t.string :image_url
      t.timestamps
    end

    add_index :part_choices, :in_stock
    add_index :part_choices, [:part_id, :in_stock]
    add_index :part_choices, [:part_id, :name]
  end
end
