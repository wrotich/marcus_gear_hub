class PricingRule < ApplicationRecord
  belongs_to :product
  belongs_to :part_choice, optional: true

  validates :conditions, presence: true
  validates :price_adjustment, presence: true, numericality: true

  # Check if this pricing rule applies to given selections
  def applies_to_selections?(selections)
    conditions.all? do |condition|
      part_id = condition["part_id"]
      choice_id = condition["choice_id"]
      selections[part_id.to_s] == choice_id || selections[part_id] == choice_id
    end
  end
end
