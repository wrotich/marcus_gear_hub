class CreateProductParts < ActiveRecord::Migration[8.0]
  def change
    create_table :product_parts do |t|
      t.references :product, null: false, foreign_key: true
      t.references :part, null: false, foreign_key: true
      t.boolean :required, default: true
      t.integer :display_order, default: 0
      t.timestamps
    end

    add_index :product_parts, [:product_id, :part_id], unique: true
    add_index :product_parts, [:product_id, :display_order]
  end
end
