class PartChoice < ApplicationRecord
  belongs_to :part
  has_many :compatibility_rules_as_condition, class_name: "CompatibilityRule", foreign_key: "condition_choice_id"
  has_many :compatibility_rules_as_target, class_name: "CompatibilityRule", foreign_key: "target_choice_id"
  has_many :pricing_rules

  validates :name, presence: true
  validates :base_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  scope :in_stock, -> { where(in_stock: true) }
  scope :for_part, ->(part) { where(part: part) }
end
