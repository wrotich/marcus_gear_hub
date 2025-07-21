class CreateCartItems < ActiveRecord::Migration[8.0]
  def change
    create_table :cart_items do |t|
      t.references :cart, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false, default: 1
      t.json :selections, null: false # {part_id => choice_id}
      t.decimal :unit_price, precision: 10, scale: 2, null: false
      t.timestamps
    end

    add_index :cart_items, :created_at
  end
end
