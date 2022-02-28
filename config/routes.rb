# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :auth do
    post 'sign_up', to: 'registrations#create'
    post 'sign_in', to: 'sessions#create'
    delete 'sign_out', to: 'sessions#destroy'
    get 'validate_token', to: 'sessions#validate_token'
  end
  resources :characters, only: %i[index show create update destroy]
  resources :programs, only: %i[index show create update destroy]
  resources :genres, only: %i[index show create update destroy]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
