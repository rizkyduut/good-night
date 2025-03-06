Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :users, only: [:create, :index] do
    resources :sleep_records, path: 'sleep-records', only: [:index] do
      post 'clock_in', on: :collection
      post 'clock_out', on: :collection
    end
  end
end
