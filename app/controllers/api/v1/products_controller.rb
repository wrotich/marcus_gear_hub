class Api::V1::ProductsController < ApplicationController
  before_action :set_product, only: [ :show, :available_options ]

  # GET /api/v1/products
  def index
    @products = Product.active.includes(:parts)
    @products = @products.where(category: params[:category]) if params[:category].present?

    render json: {
      products: @products.map do |product|
        {
          id: product.id,
          name: product.name,
          description: product.description,
          base_price: product.base_price.to_f,
          category: product.category,
          image_url: product.image_url
        }
      end
    }
  end

  # GET /api/v1/products/:id
  def show
    render json: {
      product: {
        id: @product.id,
        name: @product.name,
        description: @product.description,
        base_price: @product.base_price.to_f,
        category: @product.category,
        image_url: @product.image_url,
        parts: @product.parts.includes(:part_choices).order(:display_order).map do |part|
          {
            id: part.id,
            name: part.name,
            required: @product.product_parts.find_by(part: part).required,
            choices: part.part_choices.in_stock.map do |choice|
              {
                id: choice.id,
                name: choice.name,
                base_price: choice.base_price.to_f,
                description: choice.description
              }
            end
          }
        end
      }
    }
  end

  # POST /api/v1/products/:id/available_options
  def available_options
    current_selections = params[:selections] || {}

    # Keep selections as strings for available_options (since we fixed the model)
    available = @product.available_options(current_selections)

    # Convert to integers for calculate_price
    total_price = @product.calculate_price(current_selections)

    render json: {
      available_options: available.transform_values do |choices|
        choices.map do |choice|
          {
            id: choice.id,
            name: choice.name,
            base_price: choice.base_price.to_f,
            description: choice.description
          }
        end
      end,
      total_price: total_price.to_f
    }
  end

  private

  def set_product
    @product = Product.active.find(params[:id].to_s)
  end
end
