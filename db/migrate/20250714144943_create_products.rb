class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.text :description
      t.decimal :base_price, precision: 10, scale: 2, null: false
      t.string :category, null: false, default: 'bicycle'
      t.boolean :active, default: true
      t.string :image_url
      t.timestamps
    end

    add_index :products, :category
    add_index :products, :active
    add_index :products, [:category, :active]
  end
end
