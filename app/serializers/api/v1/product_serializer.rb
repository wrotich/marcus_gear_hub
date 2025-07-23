module Api
  module V1
    class ProductSerializer
      include JSONAPI::Serializer

      attributes :name, :description, :category, :image_url
      attribute(:base_price) { |product| product.base_price.to_f }
    end
  end
end
