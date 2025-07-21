class CreatePricingRules < ActiveRecord::Migration[8.0]
  def change
    create_table :pricing_rules do |t|
      t.references :product, null: false, foreign_key: true
      t.references :part_choice, null: true, foreign_key: true
      t.json :conditions, null: false # Array of {part_id: X, choice_id: Y} conditions
      t.decimal :price_adjustment, precision: 10, scale: 2, null: false
      t.text :description
      t.timestamps
    end

    add_index :pricing_rules, :product_id
    add_index :pricing_rules, :part_choice_id
    add_index :pricing_rules, [:product_id, :price_adjustment]
  end
end
