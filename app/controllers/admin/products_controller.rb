class Admin::ProductsController < ApplicationController
  before_action :require_admin
  before_action :set_product, only: [ :show, :edit, :update, :destroy ]

  def index
    @products = Product.all.order(:name)
  end

  def show
    @parts = @product.parts.includes(:part_choices)
  end

  def new
    @product = Product.new
    @available_parts = Part.all.order(:part_type, :name)
  end

  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to admin_product_path(@product), notice: "Product created successfully."
    else
      @available_parts = Part.all.order(:part_type, :name)
      render :new
    end
  end

  def edit
    @available_parts = Part.all.order(:part_type, :name)
    @assigned_parts = @product.parts
  end

  def update
    if @product.update(product_params)
      redirect_to admin_product_path(@product), notice: "Product updated successfully."
    else
      @available_parts = Part.all.order(:part_type, :name)
      @assigned_parts = @product.parts
      render :edit
    end
  end

  def destroy
    @product.destroy!
    redirect_to admin_products_path, notice: "Product deleted successfully."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :base_price, :category, :active, :image_url)
  end
end
