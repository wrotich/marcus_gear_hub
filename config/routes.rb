Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # API routes
  namespace :api do
    namespace :v1 do
      # Product browsing and configuration
      resources :products, only: [ :index, :show ] do
        member do
          post :available_options
        end
      end

      # Shopping cart management
      resources :cart_items, only: [ :index, :create, :update, :destroy ]

      # Order management
      resources :orders, only: [ :index, :show, :create ]

      # Simple user management (development only)
      if Rails.env.development?
        get "users", to: "users#index"
        get "user/current", to: "users#current"
        post "user/switch/:id", to: "users#switch"
        delete "user/logout", to: "users#logout"
      end
    end
  end

  # Admin Panel Routes (Rails views for Marcus)
  namespace :admin do
    # Product management
    resources :products do
      # Compatibility rules for products
      resources :compatibility_rules, except: [ :show ] do
        collection do
          get :part_choices # AJAX endpoint for dynamic form
        end
      end

      # Pricing rules for products
      resources :pricing_rules, except: [ :show ]
    end

    # Parts and choices management
    resources :parts do
      resources :part_choices, except: [ :show ]
    end

    # Order management
    resources :orders, only: [ :index, :show, :update ] do
      member do
        patch :update_status
      end
    end

    # User management (simple)
    resources :users, only: [ :index, :show, :edit, :update ]

    # Admin dashboard
    root "dashboard#index"
  end

  # Development user switching (non-API routes)
  if Rails.env.development?
    get "/dev/users", to: "dev/users#index"
    post "/dev/users/:id/switch", to: "dev/users#switch", as: :switch_user
    delete "/dev/logout", to: "dev/users#logout", as: :dev_logout
  end

  # Root - can be a simple API info page or redirect
  root to: proc { [ 200, {}, [ "Marcus Bike Shop API - Use /admin for management" ] ] }
end
