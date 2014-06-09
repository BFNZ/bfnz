Rails.application.routes.draw do
  root 'home#index'

  resources :orders, only: [:new, :create]
end
