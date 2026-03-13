class ShiftAssignmentsController < ApplicationController
  layout "app"
  before_action :require_manager!
  before_action :set_shift, only: [:create]
  before_action :set_assignment, only: [:destroy, :confirm, :decline, :cancel]

  def create
    @assignment = @shift.shift_assignments.new(
      employee_id: params[:shift_assignment][:employee_id],
      account: current_account,
      assigned_by_user: current_user,
      status: :assigned
    )

    if @assignment.save
      respond_to do |format|
        format.html { redirect_to shift_path(@shift), notice: "員工已指派" }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_to shift_path(@shift), alert: @assignment.errors.full_messages.to_sentence }
        format.turbo_stream
      end
    end
  end

  def destroy
    shift = @assignment.shift
    @assignment.destroy
    respond_to do |format|
      format.html { redirect_to shift_path(shift), notice: "指派已移除" }
      format.turbo_stream
    end
  end

  def confirm
    update_status(:confirmed)
  end

  def decline
    update_status(:declined)
  end

  def cancel
    update_status(:cancelled)
  end

  private

  def set_shift
    @shift = current_account.shifts.find(params[:shift_id])
  end

  def set_assignment
    @assignment = current_account.shift_assignments.find(params[:id])
  end

  def update_status(new_status)
    if @assignment.update(status: new_status)
      respond_to do |format|
        format.html { redirect_back fallback_location: shift_path(@assignment.shift), notice: "狀態已更新" }
        format.turbo_stream
      end
    else
      respond_to do |format|
        format.html { redirect_back fallback_location: shift_path(@assignment.shift), alert: "更新失敗" }
        format.turbo_stream
      end
    end
  end
end
