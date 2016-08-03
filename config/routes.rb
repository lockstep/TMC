Rails.application.routes.draw do
  namespace :admin do
    DashboardManifest::DASHBOARDS.each do |dashboard_resource|
      resources dashboard_resource
    end

    root controller: DashboardManifest::ROOT_DASHBOARD, action: :index
  end

  root 'pages#show', page: 'home'
  resources :pages, param: :page, only: [:show]

  get '/403', to: 'pages#show', page: 'home', as: 'error_403'
  get '/uhoh', to: 'errors#error_404', as: 'error_404'

  get '/cart', to: 'carts#my_cart', as: 'cart'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }
  resources :presentations, only: [:index, :show]

  resources :products, only: [:show, :index]
  resources :users, only: [:show, :edit, :update] do
    resources :orders, only: [:index, :show], controller: 'users/orders'
    resources :materials, only: [:index], controller: 'users/materials'
  end
  resources :orders, only: [:show, :update] do
    get 'success', on: :member
  end
  resources :line_items, only: [:create, :destroy]
  resources :charges, only: [:create]
  resources :posts, only: [:index, :show]

  get '*unmatched_route', to: 'errors#error_404'
end
