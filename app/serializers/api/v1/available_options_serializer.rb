module Api
  module V1
    class AvailableOptionsSerializer
      include JSONAPI::Serializer

      attribute :available_options do |data|
        data[:available_options].transform_values do |choices|
          choices.map do |choice|
            {
              id: choice.id,
              name: choice.name,
              base_price: choice.base_price.to_f,
              description: choice.description
            }
          end
        end
      end
      attribute(:total_price) { |data| data[:total_price].to_f }
    end
  end
end
