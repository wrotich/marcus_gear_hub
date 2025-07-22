class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :status, presence: true
  validates :total_amount, presence: true, numericality: { greater_than: 0 }

  enum :status, {
    pending: "pending",
    confirmed: "confirmed", 
    processing: "processing",
    shipped: "shipped",
    delivered: "delivered",
    cancelled: "cancelled"
  }
end
