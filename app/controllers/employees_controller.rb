class EmployeesController < ApplicationController
  before_action :require_manager!
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  def index
    @employees = current_account.employees
                                .includes(:location, :user)
                                .order(:name)
  end

  def show
  end

  def new
    @employee = current_account.employees.new(status: :active)
    @locations = current_account.locations.order(:name)
  end

  def create
    @employee = current_account.employees.new(employee_params)
    if @employee.save
      redirect_to employees_path, notice: "員工「#{@employee.name}」建立成功"
    else
      @locations = current_account.locations.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @locations = current_account.locations.order(:name)
  end

  def update
    if @employee.update(employee_params)
      redirect_to employees_path, notice: "員工資料已更新"
    else
      @locations = current_account.locations.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @employee.destroy
    redirect_to employees_path, notice: "員工已移除"
  end

  private

  def set_employee
    @employee = current_account.employees.find(params[:id])
  end

  def employee_params
    params.require(:employee).permit(:name, :phone, :location_id, :user_id,
                                     :status, :start_on, :end_on)
  end
end
