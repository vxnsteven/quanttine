Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, path: 'users'
  resources :users do
    resources :avatars, only: [:create]
    resources :profiles
  end

  devise_for :admins, path: 'admins'
  resources :admins, only: [:show] do
    resources :school_meals
    resources :servings
    resources :statistics, only: [:index]
    resources :profiles, only: [:index]
  end

  resources :payments, only: [:new]
  resources :charge_payments, only: [:new, :create]
  resources :subscription_payments, only: [:new, :create]
end
