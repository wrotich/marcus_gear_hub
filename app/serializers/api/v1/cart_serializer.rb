module Api
  module V1
    class CartSerializer
      include JSONAPI::Serializer

      attribute(:total_price) { |object| object.total_price.to_f }
      attribute(:item_count) { |object| object.item_count }
      attribute :items do |object|
        Api::V1::CartItemSerializer.new(object.cart_items.includes(:product)).serializable_hash[:data].map { |item| item[:attributes] }
      end
    end
  end
end
