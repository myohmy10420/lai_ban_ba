class DashboardController < ApplicationController
  layout "app"
  before_action :require_account!

  def index
    @upcoming_shifts = current_account.shifts
                                      .upcoming
                                      .includes(:location, shift_assignments: :employee)
                                      .limit(10)
    @active_employees_count = current_account.employees.active.count
    @locations = current_account.locations.order(:name)
  end
end
