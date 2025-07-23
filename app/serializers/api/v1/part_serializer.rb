module Api
  module V1
    class PartSerializer
      include JSONAPI::Serializer

      attributes :name
      attribute :required do |part, params|
        product = params[:product]
        product.product_parts.find_by(part: part).required
      end
      attribute :choices do |part|
        part.part_choices.in_stock.map do |choice|
          {
            id: choice.id,
            name: choice.name,
            base_price: choice.base_price.to_f,
            description: choice.description
          }
        end
      end
    end
  end
end
