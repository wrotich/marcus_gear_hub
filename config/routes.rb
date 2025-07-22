Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # API routes
  namespace :api do
    namespace :v1 do
      resources :products, only: [ :index, :show ] do
        member do
          post :available_options
        end
      end
      resources :cart_items, only: [ :index, :create, :update, :destroy ]
    end
  end

  # Root - can be a simple API info page or redirect
  root to: proc { [ 200, {}, [ "Marcus Bike Shop API - Use /admin for management" ] ] }
end
