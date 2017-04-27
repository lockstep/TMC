Rails.application.routes.draw do

  namespace :admin do
    authenticate :user, lambda { |user| user.admin? } do
      mount Searchjoy::Engine, at: "searchjoy"
    end

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
  post '/directory/join', to: 'directory#join_directory'
  get '/directory/profile/:user_id', to: 'directory#profile',
    as: 'directory_profile'
  get '/aws_s3_auth', to: 'aws_services#aws_s3_auth'

  get '/admin/become/users/:id', to: 'admin/users#become',
    as: 'become_user'

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

    collection do
      get :edit_profile
    end
    member do
      get :edit_address
      get :profile
    end
    resources :orders, only: [:index, :show], controller: 'users/orders'
    resources :materials, only: [:index], controller: 'users/materials'

    controller :feed_items do
      post :send_message
    end

    controller :feed_policies do
      patch :toggle_private_messages_enabled
      patch :toggle_user_blocked
    end

    patch :add_interest, to: 'interests#add_user_interest'

  end


  resources :orders, only: [:show, :update] do
    get 'success', on: :member
  end
  resources :line_items, only: [:create, :destroy]
  resources :charges, only: [:create]
  resources :posts, only: [:index, :show]
  post :join_newsletter, to: 'guests#join_newsletter'

  resources :breakout_sessions, only: [:show] do
    controller :feed_items do
      post :send_breakout_session_comment
    end
    post :join_session, to: 'breakout_sessions#join_session',
      as: 'join'
  end

  resources :conferences, only: [:show] do
    member do
      resources :breakout_sessions, only: [ :new, :create ]
    end
  end

  resources :interests, only: [:show] do
    controller :feed_items do
      post :send_interest_comment
    end
  end

  namespace :api, defaults: { format: 'json' } do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'users', controllers: {
        sessions: 'api/v1/users/sessions'
      }, skip: [ :omniauth_callbacks ]

      post '/users/:user_id/send_message', to: 'feed_items#send_message'
      resources :users, only: [] do
        member do
          resources :private_messages, only: [ :index ]
        end
      end

      resources :conferences, only: [:index, :show] do
        resources :images, only: [ :index, :create ]
        member do
          resources :breakout_sessions, only: [:index]
        end
      end

      resources :breakout_sessions, only: [:index, :show]
      resource :aws_s3_auth, only: [:show]
    end
  end

end
