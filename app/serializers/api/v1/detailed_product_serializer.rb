module Api
  module V1
    class DetailedProductSerializer
      include JSONAPI::Serializer

      attributes :name, :description, :category, :image_url

      attribute(:base_price) { |product| product.base_price.to_f }

      attribute :parts do |product|
        product.parts.order(:display_order).map do |part|
          {
            id: part.id,
            name: part.name,
            required: product.product_parts.find { |pp| pp.part_id == part.id }&.required,
            choices: part.part_choices.select(&:in_stock?).map do |choice|
              {
                id: choice.id,
                name: choice.name,
                base_price: choice.base_price.to_f,
                description: choice.description
              }
            end
          }
        end
      end
    end
  end
end
