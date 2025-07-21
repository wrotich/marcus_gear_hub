class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone
      t.string :role, null: false, default: 'customer'
      t.boolean :active, default: true
      t.timestamps
    end

    add_index :users, :email, unique: true
    add_index :users, :role
    add_index :users, :active
    add_index :users, [:role, :active]
  end
end
