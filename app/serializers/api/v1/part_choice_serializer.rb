module Api
  module V1
    class PartChoiceSerializer
      include JSONAPI::Serializer

      set_type :part_choice

      attributes :id, :name, :base_price, :description
      attribute :base_price do |object|
        object.base_price.to_f
      end
    end
  end
end
