class CreateCompatibilityRules < ActiveRecord::Migration[8.0]
  def change
    create_table :compatibility_rules do |t|
      t.references :product, null: false, foreign_key: true
      t.references :condition_part, null: false, foreign_key: { to_table: :parts }
      t.references :condition_choice, null: false, foreign_key: { to_table: :part_choices }
      t.references :target_part, null: true, foreign_key: { to_table: :parts }
      t.references :target_choice, null: true, foreign_key: { to_table: :part_choices }
      t.string :action, null: false # 'restrict' or 'exclude'
      t.text :description
      t.timestamps
    end

    add_index :compatibility_rules, [:product_id, :condition_part_id, :condition_choice_id], 
              name: 'index_compatibility_rules_on_condition'
    add_index :compatibility_rules, [:product_id, :action]
    add_index :compatibility_rules, :condition_part_id
    add_index :compatibility_rules, :target_part_id
  end
end
