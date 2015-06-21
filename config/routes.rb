Rails.application.routes.draw do
  root 'home#index'

  resources :orders, only: [:new, :create]

  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout
  resources :user_sessions, only: [:create]

  namespace :admin do
    get '/' => 'home#index', as: :root
    get '/orders' => 'search#index'

    resources :customers, only: [:new, :create, :edit, :update] do
      member do
        get 'find_duplicate'
        post 'merge'
      end
      resources :orders, only: [:new, :create, :destroy, :update]
    end

    resources :orders, only: [] do
      member do
        put :mark_duplicate
        put :unmark_duplicate
      end
    end

    resources :labels, only: [:index]
    resources :shipments, only: [:index, :show]
    resources :contact_lists, only: [:index, :show]
    resources :coordinators, except: [:show, :destroy]
  end
end
