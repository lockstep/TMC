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
  get '/404', to: 'pages#show', page: 'home', as: 'error_404'

  devise_for :users, controllers: {
    sessions: 'users/sessions',
    confirmations: 'users/confirmations'
  }
  resources :presentations, only: [:index, :show]

  resources :products, only: [:show]
  resources :users, only: [:show, :edit, :update] do
    resources :orders, only: [:index, :show], controller: 'users/orders'
  end
  resources :orders do
    resources :line_items, only: [:create, :destroy]
    resources :charges, only: [:show, :new, :create]
  end
end
