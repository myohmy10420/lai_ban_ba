class AccountsController < ApplicationController
  layout "application"
  before_action :authenticate_user!

  def new
    @account = Account.new
  end

  def create
    @account = Account.new(account_params)
    if @account.save
      @account.memberships.create!(user: current_user, role: :owner)
      session[:current_account_id] = @account.id
      redirect_to dashboard_path, notice: "帳號「#{@account.name}」建立成功！"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def switch
    account = current_user.accounts.find(params[:id])
    session[:current_account_id] = account.id
    redirect_back fallback_location: dashboard_path, notice: "已切換到「#{account.name}」"
  end

  private

  def account_params
    params.require(:account).permit(:name)
  end
end
