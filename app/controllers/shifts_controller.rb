class ShiftsController < ApplicationController
  before_action :require_account!
  before_action :set_shift, only: [:show, :edit, :update, :destroy]

  def index
    @view_mode = params[:view].presence || "week"

    if @view_mode == "month"
      @month_start = params[:date].present? ? Date.parse(params[:date]).beginning_of_month : Date.today.beginning_of_month
      @month_end   = @month_start.end_of_month
      @shifts = current_account.shifts
                               .where(starts_at: @month_start.beginning_of_day..@month_end.end_of_day)
                               .includes(:location, shift_assignments: :employee)
                               .order(:starts_at)
      @shifts_by_date = @shifts.group_by { |s| s.starts_at.to_date }
      @locations = current_account.locations.order(:name)
    elsif @view_mode == "week"
      @week_start = params[:date].present? ? Date.parse(params[:date]).beginning_of_week(:sunday) : Date.today.beginning_of_week(:sunday)
      @week_dates = (@week_start..@week_start + 6.days).to_a
      @shifts = current_account.shifts
                               .where(starts_at: @week_start.beginning_of_day..(@week_start + 6.days).end_of_day)
                               .includes(:location, shift_assignments: :employee)
                               .order(:starts_at)
      @shifts_by_date = @shifts.group_by { |s| s.starts_at.to_date }
      @locations = current_account.locations.order(:name)
    else
      @date = params[:date].present? ? Date.parse(params[:date]) : Date.today
      @shifts = current_account.shifts
                               .for_date(@date)
                               .includes(:location, shift_assignments: :employee)
                               .order(:starts_at)
    end
  end

  def show
    @available_employees = current_account.employees
                                          .active
                                          .where.not(id: @shift.employees.select(:id))
                                          .order(:name)
  end

  def new
    default_date = params[:date].present? ? Date.parse(params[:date]) : Date.today
    @shift = current_account.shifts.new(source: "manual", starts_at: default_date)
    @locations = current_account.locations.order(:name)
  end

  def create
    @shift = current_account.shifts.new(shift_params.merge(source: "manual"))
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

  def copy_from_last_week
    require_manager!
    return if performed?

    target_date = Date.parse(params[:date])
    source_date = target_date - 7.days
    source_shifts = current_account.shifts.for_date(source_date)
    existing_shifts = current_account.shifts.for_date(target_date)

    if source_shifts.empty?
      return redirect_to shifts_path(date: target_date.to_s),
        alert: "上週同一天（#{source_date.strftime("%-m/%-d")}）沒有班次可複製"
    end

    if existing_shifts.any? && params[:overwrite] != "true"
      return redirect_to shifts_path(date: target_date.to_s),
        flash: { confirm_copy: { date: target_date.to_s, count: existing_shifts.count } }
    end

    copied_count = 0
    Shift.transaction do
      existing_shifts.destroy_all if params[:overwrite] == "true"
      source_shifts.each do |src|
        current_account.shifts.create!(
          location_id:        src.location_id,
          starts_at:          src.starts_at + 7.days,
          ends_at:            src.ends_at + 7.days,
          required_headcount: src.required_headcount,
          role_tag:           src.role_tag,
          source:             "manual",
          note:               src.note
        )
        copied_count += 1
      end
    end

    redirect_to shifts_path(date: target_date.to_s), notice: "已複製 #{copied_count} 個班次"
  rescue Date::Error, ArgumentError
    redirect_to shifts_path, alert: "日期格式錯誤"
  end

  def batch_create
    require_manager!
    return if performed?

    shifts_data = params[:shifts] || []
    created = 0
    errors  = []

    Shift.transaction do
      shifts_data.each do |sp|
        date      = Date.parse(sp[:date].to_s)
        starts_at = Time.zone.parse("#{date} #{sp[:starts_at_time]}")
        ends_at   = Time.zone.parse("#{date} #{sp[:ends_at_time]}")
        shift = current_account.shifts.build(
          location_id:        sp[:location_id],
          role_tag:           sp[:role_tag],
          starts_at:          starts_at,
          ends_at:            ends_at,
          required_headcount: sp[:required_headcount].to_i,
          source:             "manual"
        )
        if shift.save
          created += 1
        else
          errors << "#{date}: #{shift.errors.full_messages.join(", ")}"
        end
      end
      raise ActiveRecord::Rollback if errors.any?
    end

    if errors.any?
      render json: { ok: false, errors: errors }, status: :unprocessable_entity
    else
      render json: { ok: true, created_count: created }
    end
  rescue Date::Error, ArgumentError => e
    render json: { ok: false, errors: [e.message] }, status: :unprocessable_entity
  end

  private

  def set_shift
    @shift = current_account.shifts.find(params[:id])
  end

  def shift_params
    params.require(:shift).permit(:location_id, :starts_at, :ends_at,
                                  :required_headcount, :role_tag,
                                  :note, :lock_version)
  end
end
