require 'resque/server'

Rails.application.routes.draw do
  root to: 'static_pages#home'

  resources :listings, only: [:index, :show]
  resources :reservations
  # resources :webhooks, only: [:create]
  post '/webhooks/:source' => 'webhooks#create'
  # get "users/oauth/google/callback", to: "omniauth_callabacks#google_oauth2"
  # http://localhost:3000/users/oauth/google/callback
  namespace :host do
    resources :listings do
      resources :photos, only: [:index, :create, :destroy, :new]
      resources :rooms, only: [:index, :create, :destroy] # /host/listings/:listing_id/room/2
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  resque_web_constraint = lambda do |request|
    current_user = request.env['warden'].user
    current_user.id == 4
    end
  constraints resque_web_constraint do
    mount Resque::Server, at: '/jobs'
  end

  end

