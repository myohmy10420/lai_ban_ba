class LocationsController < ApplicationController
  before_action :require_owner!
  before_action :set_location, only: [:show, :edit, :update, :destroy]

  def index
    @locations = current_account.locations.order(:name)
  end

  def show
  end

  def business_hours
    day = params[:day_of_week].to_i
    bh = @location.business_hours.find_by(day_of_week: day)
    if bh && !bh.is_closed?
      render json: {
        opens_at: bh.opens_at.strftime("%H:%M"),
        closes_at: bh.closes_at.strftime("%H:%M")
      }
    else
      render json: { closed: true }
    end
  end

  def new
    @location = current_account.locations.new
    build_missing_business_hours(@location)
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
    build_missing_business_hours(@location)
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
    params.require(:location).permit(
      :name, :address,
      business_hours_attributes: [:id, :day_of_week, :opens_at, :closes_at, :is_closed]
    )
  end

  def build_missing_business_hours(location)
    existing_days = location.business_hours.map(&:day_of_week)
    (0..6).each do |day|
      location.business_hours.build(day_of_week: day) unless existing_days.include?(day)
    end
  end
end
