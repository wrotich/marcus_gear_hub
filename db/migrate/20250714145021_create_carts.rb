class CreateCarts < ActiveRecord::Migration[8.0]
  def change
    create_table :carts do |t|
      t.references :user, null: true, foreign_key: true
      t.string :session_id # For guest users
      t.timestamps
    end

    add_index :carts, :session_id, unique: true
    add_index :carts, :created_at

    # Add constraint: either user_id OR session_id must be present
    execute <<-SQL
      ALTER TABLE carts 
      ADD CONSTRAINT user_or_session_required 
      CHECK ((user_id IS NOT NULL) OR (session_id IS NOT NULL))
    SQL
  end
end
