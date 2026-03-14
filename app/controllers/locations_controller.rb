class LocationsController < ApplicationController
  before_action :require_owner!
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = current_account.locations.order(:name)
  end

  def show
  end

  def new
    @location = current_account.locations.new
  end

  def create
    @location = current_account.locations.new(location_params)
    if @location.save
      redirect_to locations_path, notice: "門市「#{@location.name}」建立成功"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @location.update(location_params)
      redirect_to locations_path, notice: "門市資料已更新"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @location.destroy
    redirect_to locations_path, notice: "門市已刪除"
  end

  private

  def set_location
    @location = current_account.locations.find(params[:id])
  end

  def location_params
    params.require(:location).permit(:name, :address)
  end
end
