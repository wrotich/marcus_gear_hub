class Admin::PartChoicesController < ApplicationController
  before_action :require_admin
  before_action :set_part
  before_action :set_part_choice, only: [ :edit, :update, :destroy ]

  def new
    @part_choice = @part.part_choices.build
  end

  def create
    @part_choice = @part.part_choices.build(part_choice_params)

    if @part_choice.save
      redirect_to admin_part_path(@part), notice: "Part choice created successfully."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @part_choice.update(part_choice_params)
      redirect_to admin_part_path(@part), notice: "Part choice updated successfully."
    else
      render :edit
    end
  end

  def destroy
    @part_choice.destroy!
    redirect_to admin_part_path(@part), notice: "Part choice deleted successfully."
  end

  private

  def set_part
    @part = Part.find(params[:part_id])
  end

  def set_part_choice
    @part_choice = @part.part_choices.find(params[:id])
  end

  def part_choice_params
    params.require(:part_choice).permit(:name, :base_price, :in_stock, :description, :image_url)
  end
end
