Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  get 'users/edit'
  devise_for :users
  get 'accounts/index'
  get 'accounts/show'
  get 'accounts/create'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  resources :credit_applications, only: %i[index show new create edit] do
    collection do
      post :bulk_evaluate
    end
  end
  resources :users, only: %i[index show edit]
  resources :accounts, only: %i[index show create]
  resources :accounts do
    get :transactions, on: :member
  end
  resources :transactions, only: [:create]

  namespace :api do
    post "slack/new-user", to: "slack#new-users"
  end
  root "credit_applications#index"
end
