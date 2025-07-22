class Api::V1::CartItemsController < ApplicationController
  before_action :set_cart_item, only: [ :update, :destroy ]

  def index
    render json: {
      cart: {
        items: current_cart.cart_items.includes(:product).map do |item|
          {
            id: item.id,
            product_name: item.product.name,
            configuration: item.configuration_summary,
            quantity: item.quantity,
            unit_price: item.unit_price.to_f,
            total_price: item.total_price.to_f
          }
        end,
        total_price: current_cart.total_price.to_f,
        item_count: current_cart.item_count
      }
    }
  end

  def create
    @product = Product.find(params[:product_id].to_i)
    selections = params[:selections] || {}

    required_parts = @product.product_parts.where(required: true).includes(:part)
    missing_parts = required_parts.reject do |product_part|
      selections[product_part.part.id.to_s].present?
    end

    if missing_parts.any?
      return render json: {
        error: "Missing required parts: #{missing_parts.map { |pp| pp.part.name }.join(', ')}"
      }, status: :unprocessable_entity
    end

    existing_items = current_cart.cart_items.where(product: @product)
    existing_item = existing_items.find { |item| item.selections == selections }

    if existing_item
      existing_item.update!(quantity: existing_item.quantity + 1)
      @cart_item = existing_item
    else
      @cart_item = current_cart.cart_items.create!(
        product: @product,
        selections: selections,
        quantity: 1
      )
    end

    render json: {
      success: true,
      cart_item: {
        id: @cart_item.id,
        product_name: @cart_item.product.name,
        configuration: @cart_item.configuration_summary,
        quantity: @cart_item.quantity,
        unit_price: @cart_item.unit_price.to_f,
        total_price: @cart_item.total_price.to_f
      },
      cart_total: current_cart.total_price.to_f,
      cart_count: current_cart.item_count
    }
  end

  def update
    if @cart_item.update(quantity: params[:quantity])
      render json: {
        success: true,
        cart_item: {
          id: @cart_item.id,
          quantity: @cart_item.quantity,
          total_price: @cart_item.total_price.to_f
        },
        cart_total: current_cart.total_price.to_f
      }
    else
      render json: { error: @cart_item.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @cart_item.destroy!
    render json: {
      success: true,
      cart_total: current_cart.total_price.to_f,
      cart_count: current_cart.item_count
    }
  end

  private

  def set_cart_item
    @cart_item = current_cart.cart_items.find(params[:id])
  end
end
