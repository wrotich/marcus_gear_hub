class Part < ApplicationRecord
  has_many :product_parts, dependent: :destroy
  has_many :products, through: :product_parts
  has_many :part_choices, dependent: :destroy
  has_many :compatibility_rules_as_condition, class_name: "CompatibilityRule", foreign_key: "condition_part_id"
  has_many :compatibility_rules_as_target, class_name: "CompatibilityRule", foreign_key: "target_part_id"

  validates :name, presence: true
  validates :part_type, presence: true

  scope :for_product, ->(product) { joins(:products).where(products: { id: product.id }) }
end
