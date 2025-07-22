class ProductPart < ApplicationRecord
  belongs_to :product
  belongs_to :part

  validates :product_id, uniqueness: { scope: :part_id }
  validates :required, inclusion: { in: [ true, false ] }
end
