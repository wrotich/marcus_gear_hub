class CreateOrders < ActiveRecord::Migration[8.0]
  def change
    create_table :orders do |t|
      t.references :user, null: true, foreign_key: true
      t.string :status, null: false, default: 'pending'
      t.decimal :total_amount, precision: 10, scale: 2, null: false
      t.text :shipping_address
      t.text :billing_address
      t.text :notes
      t.string :customer_email
      t.string :customer_name
      t.string :customer_phone
      t.timestamps
    end

    add_index :orders, :user_id
    add_index :orders, :status
    add_index :orders, :created_at
    add_index :orders, [:status, :created_at]
    add_index :orders, [:user_id, :status]
    add_index :orders, [:user_id, :created_at]
    add_index :orders, :customer_email
  end
end
