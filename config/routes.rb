Rails.application.routes.draw do
  root 'home#index'

  devise_for :users, path: 'users'
  devise_for :admins, path: 'admins'

  resources :users do
    resources :profiles
  end

  resources :admins, only: [:show]

  resources :admins, only: [:show] do
    resources :menus
  end

end
