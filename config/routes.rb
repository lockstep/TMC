Rails.application.routes.draw do
  namespace :admin do
    DashboardManifest::DASHBOARDS.each do |dashboard_resource|
      resources dashboard_resource
    end

    resources :products do
      member do
        post :create_alternate_language
      end
    end

    root controller: DashboardManifest::ROOT_DASHBOARD, action: :index
  end

  root 'pages#show', page: 'home'
  resources :pages, param: :page, only: [:show]

  get '/403', to: 'pages#show', page: 'home', as: 'error_403'
  get '/cart', to: 'carts#my_cart', as: 'cart'
  get '/directory', to: 'directory#index'
  get '/directory/profile/:user_id', to: 'directory#profile',
    as: 'directory_profile'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  resources :products, only: [:show, :index] do
    member do
      get :shipping
      get :change_language
    end
  end
  resources :users, only: [:show, :edit, :update] do
    member do
      get :edit_address
      get :profile
      get :edit_profile
    end
    resources :orders, only: [:index, :show], controller: 'users/orders'
    resources :materials, only: [:index], controller: 'users/materials'
    controller :feed_items do
      post :send_message
    end
  end
  resources :orders, only: [:show, :update] do
    get 'success', on: :member
  end
  resources :line_items, only: [:create, :destroy]
  resources :charges, only: [:create]
  resources :posts, only: [:index, :show]
  post :join_newsletter, to: 'guests#join_newsletter'
end
