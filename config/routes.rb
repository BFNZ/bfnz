Rails.application.routes.draw do
  root 'home#index'

  resources :orders, only: [:new, :create]

  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout
  resources :user_sessions, only: [:create]

  namespace :admin do
    get '/' => 'orders#index', as: :root
    resources :orders, except: [:destroy]
    resources :labels, only: [:index]
    resources :shipments, only: [:index, :show]
  end
end
