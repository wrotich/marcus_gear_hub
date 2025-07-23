module Api
  module V1
    class CartItemSerializer
      include JSONAPI::Serializer

      set_type :cart_item

      attributes :id, :quantity, :unit_price, :total_price
      attribute(:product_name) { |object| object.product.name }
      attribute(:configuration) { |object| object.configuration_summary }
    end
  end
end
