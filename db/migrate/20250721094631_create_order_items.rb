class CreateOrderItems < ActiveRecord::Migration[8.0]
  def change
    create_table :order_items do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity, null: false
      t.decimal :unit_price, precision: 10, scale: 2, null: false
      t.json :selections, null: false # Configuration snapshot
      t.string :product_name, null: false # Snapshot of product name at time of order
      t.text :product_description # Snapshot of product description
      t.timestamps
    end

    add_index :order_items, :order_id
    add_index :order_items, :product_id
    add_index :order_items, [:order_id, :product_id]
  end
end
