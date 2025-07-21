class Admin::PartsController < ApplicationController
  before_action :require_admin
  before_action :set_part, only: [:show, :edit, :update, :destroy]

  def index
    @parts = Part.includes(:part_choices).order(:part_type, :name)
  end

  def show
    @part_choices = @part.part_choices.order(:name)
  end

  def new
    @part = Part.new
  end

  def create
    @part = Part.new(part_params)

    if @part.save
      redirect_to admin_part_path(@part), notice: 'Part created successfully.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @part.update(part_params)
      redirect_to admin_part_path(@part), notice: 'Part updated successfully.'
    else
      render :edit
    end
  end

  def destroy
    @part.destroy!
    redirect_to admin_parts_path, notice: 'Part deleted successfully.'
  end

  private

  def set_part
    @part = Part.find(params[:id])
  end

  def part_params
    params.require(:part).permit(:name, :part_type, :description)
  end
end
