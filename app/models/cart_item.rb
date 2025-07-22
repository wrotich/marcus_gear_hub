class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than: 0 }
  validates :selections, presence: true # JSON field storing part/choice selections
  validates :unit_price, presence: true, numericality: { greater_than: 0 }

  before_validation :calculate_unit_price, if: -> { product.present? && selections.present? }

  def total_price
    unit_price * quantity
  end

  def configuration_summary
    return {} if selections.blank?

    summary = {}
    selections.each do |part_id, choice_id|
      part = Part.find_by(id: part_id.to_i)
      choice = PartChoice.find_by(id: choice_id)
      summary[part.name] = choice.name if part && choice
    end
    summary
  end

  private

  def calculate_unit_price
    selections_with_int_keys = selections.transform_keys(&:to_i)
    self.unit_price = product.calculate_price(selections_with_int_keys)
  end
end
