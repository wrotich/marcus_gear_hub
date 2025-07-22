class Product < ApplicationRecord
  include ProductCompatibility

  has_many :product_parts, dependent: :destroy
  has_many :parts, through: :product_parts
  has_many :compatibility_rules, dependent: :destroy
  has_many :pricing_rules, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  validates :name, presence: true
  validates :base_price, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true

  scope :active, -> { where(active: true) }

  # Calculate total price based on selections
  def calculate_price(selections = {})
    total = base_price

    # Add base part prices
    selections.each do |part_id, choice_id|
      choice = PartChoice.find_by(id: choice_id)
      total += choice.base_price if choice
    end

    # Apply pricing rules (conditional pricing)
    pricing_rules.each do |rule|
      if rule.applies_to_selections?(selections)
        total += rule.price_adjustment
      end
    end

    total
  end
end
