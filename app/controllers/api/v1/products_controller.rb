class Api::V1::ProductsController < ApplicationController
  require "ostruct"

  before_action :set_product, only: [ :show, :available_options ]

  def index
    @products = Product.active.includes(:parts)
    @products = @products.where(category: params[:category]) if params[:category].present?

    serialized_products = Api::V1::ProductSerializer.new(@products).serializable_hash

    render json: {
      products: serialized_products[:data].map do |product_data|
        product_data[:attributes].merge(id: product_data[:id])
      end
    }
  end

  def show
    serialized_product = Api::V1::DetailedProductSerializer.new(@product).serializable_hash
    render json: {
      product: serialized_product[:data][:attributes].merge(id: @product.id)
    }
  end

  def available_options
    current_selections = params[:selections] || {}
    available = @product.available_options(current_selections)
    total_price = @product.calculate_price(current_selections)

    data_object = OpenStruct.new(
      id: @product.id,
      available_options: available,
      total_price: total_price
    )

    serialized_data = Api::V1::AvailableOptionsSerializer.new(data_object).serializable_hash
    render json: serialized_data[:data][:attributes]
  end

  private

  def set_product
    @product = Product.active.includes(parts: :part_choices).find(params[:id])
  end
end
