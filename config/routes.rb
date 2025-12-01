Rails.application.routes.draw do
  devise_for :users
  root to: "pages#home"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  get "map", to: "story_levels#map", as: :map

  # for selecting attack type (question type) when in fight. This is hooked up to the _menu_contents.html.erb buttons.


  resources :fights, only: [:show, :create, :update, :index] do
    resources :fight_questions, only: [:show, :create, :index]
  end
  resources :fight_questions, only: [:update]
  resources :users, only: [:update]
end
