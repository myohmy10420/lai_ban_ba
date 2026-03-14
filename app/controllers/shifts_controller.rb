class ShiftsController < ApplicationController
  before_action :require_account!
  before_action :set_shift, only: [:show, :edit, :update, :destroy]

  def index
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @shifts = current_account.shifts
                             .for_date(@date)
                             .includes(:location, shift_assignments: :employee)
                             .order(:starts_at)
  end

  def show
    @available_employees = current_account.employees
                                          .active
                                          .where.not(id: @shift.employees.select(:id))
                                          .order(:name)
  end

  def new
    @shift = current_account.shifts.new(source: "manual")
    @locations = current_account.locations.order(:name)
  end

  def create
    @shift = current_account.shifts.new(shift_params)
    if @shift.save
      redirect_to shifts_path, notice: "班次建立成功"
    else
      @locations = current_account.locations.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @locations = current_account.locations.order(:name)
  end

  def update
    if @shift.update(shift_params)
      redirect_to shift_path(@shift), notice: "班次已更新"
    else
      @locations = current_account.locations.order(:name)
      render :edit, status: :unprocessable_entity
    end
  rescue ActiveRecord::StaleObjectError
    flash.now[:alert] = "班次已被其他人修改，請重新載入後再試"
    @locations = current_account.locations.order(:name)
    render :edit, status: :conflict
  end

  def destroy
    @shift.destroy
    redirect_to shifts_path, notice: "班次已刪除"
  end

  private

  def set_shift
    @shift = current_account.shifts.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:location_id, :starts_at, :ends_at,
                                  :required_headcount, :role_tag, :source,
                                  :note, :lock_version)
  end
end
