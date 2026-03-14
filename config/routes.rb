Rails.application.routes.draw do
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  # 已登入且有 account → dashboard；未登入 → landing page
  authenticated :user do
    root "dashboard#index", as: :authenticated_root
  end
  root "home#index"

  # Account 建立 / 切換
  resources :accounts, only: [:new, :create] do
    member do
      post :switch
    end
  end

  # 核心業務資源（都在 current_account 的 scope 下）
  get "dashboard", to: "dashboard#index", as: :dashboard

  resources :locations do
    member do
      get :business_hours
    end
  end
  resources :employees

  resources :shifts do
    resources :shift_assignments, only: [:create, :destroy], shallow: true do
      member do
        patch :confirm
        patch :decline
        patch :cancel
      end
    end
  end
end
