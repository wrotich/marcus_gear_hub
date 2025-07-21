class Product < ApplicationRecord
  has_many :product_parts, dependent: :destroy
  has_many :parts, through: :product_parts
  has_many :compatibility_rules, dependent: :destroy
  has_many :pricing_rules, dependent: :destroy
  has_many :cart_items, dependent: :destroy

  validates :name, presence: true
  validates :base_price, presence: true, numericality: { greater_than: 0 }
  validates :category, presence: true

  scope :active, -> { where(active: true) }

  # Calculate available options based on current selections and rules
  def available_options(current_selections = {})
    available = {}

    parts.each do |part|
      available_choices = part.part_choices.in_stock

      # Apply compatibility rules
      compatibility_rules.each do |rule|
        if current_selections[rule.condition_part_id] == rule.condition_choice_id
          if rule.action == "restrict"
            available_choices = available_choices.where(id: rule.target_choice_id) if rule.target_choice_id
          elsif rule.action == "exclude"
            available_choices = available_choices.where.not(id: rule.target_choice_id) if rule.target_choice_id
          end
        end
      end

      available[part.id] = available_choices.to_a
    end

    available
  end

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
