Rails.application.routes.draw do
  get 'staticpages/AboutTheBible',:as => 'aboutthebible_page'

  get 'staticpages/FAQ',:as => 'FAQ_page'

  get 'staticpages/Links',:as => 'Links_page'

  get 'staticpages/BibleTranslation',:as => 'bibletranslation_page'

  get 'staticpages/QuickRef',:as => 'quickref_page'

  get 'staticpages/Sample',:as => 'sample_page'

  get 'staticpages/Subject',:as => 'subject_page'

  get 'staticpages/Gospel',:as => 'gospel_page'

  get 'staticpages/Books',:as => 'books_page'

   root 'home#index'

  resources :orders, only: [:new, :create]

  get 'login' => 'user_sessions#new', as: :login
  post 'logout' => 'user_sessions#destroy', as: :logout
  resources :user_sessions, only: [:create]

  namespace :admin do
    get '/' => 'home#index', as: :root
    get '/orders' => 'search#index'

    resources :customers, only: [:new, :create, :edit, :update] do
      post 'find_duplicate_by_name_or_address', on: :collection
      member do
        get 'find_duplicate'
        post 'merge'
      end
      resources :orders, only: [:new, :create, :destroy, :update]
    end

    resources :labels, only: [:index]
    resources :shipments, only: [:index, :show]
    resources :contact_lists, only: [:index, :show, :create]
    resources :coordinators, except: [:show, :destroy]
  end
end
