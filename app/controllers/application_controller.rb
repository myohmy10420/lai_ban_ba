class ApplicationController < ActionController::Base
  allow_browser versions: :modern

  helper_method :current_account, :current_membership

  private

  def current_account
    return @current_account if defined?(@current_account)
    @current_account = current_user&.accounts&.find_by(id: session[:current_account_id])
    @current_account ||= current_user&.accounts&.first
  end

  def current_membership
    return @current_membership if defined?(@current_membership)
    @current_membership = current_user&.memberships&.find_by(account: current_account)
  end

  def require_account!
    authenticate_user!
    redirect_to new_account_path, alert: "請先建立或加入一個帳號" and return unless current_account
  end

  def require_manager!
    require_account!
    return if performed?
    unless current_membership&.owner? || current_membership&.manager?
      redirect_to dashboard_path, alert: "您沒有權限執行此操作"
    end
  end

  def require_owner!
    require_account!
    return if performed?
    unless current_membership&.owner?
      redirect_to dashboard_path, alert: "僅限帳號擁有者"
    end
  end
end
