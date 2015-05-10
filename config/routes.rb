Rails.application.routes.draw do
  root 'home#index'

  resources :orders, only: [:new, :create]

  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout
  resources :user_sessions, only: [:create]

  namespace :admin do
    get '/' => 'home#index', as: :root
    resources :orders, except: [:destroy] do
      member do
        put :mark_duplicate
        put :unmark_duplicate
      end
    end
    resources :labels, only: [:index]
    resources :shipments, only: [:index, :show]
    resources :contact_lists, only: [:index, :show]
    resources :coordinators, except: [:destroy]
  end
end
