Rails.application.routes.draw do
  namespace :admin do
    DashboardManifest::DASHBOARDS.each do |dashboard_resource|
      resources dashboard_resource
    end

    root controller: DashboardManifest::ROOT_DASHBOARD, action: :index
  end

  root 'pages#show', page: 'home'
  get 'pages/:page' => 'pages#show'

  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  resources :presentations, only: [:index, :show]

  resources :products, only: [:show]
  resources :orders do
    resources :line_items, only: [:create, :destroy]
    resources :charges, only: [:show, :new, :create]
  end
end
