require 'resque/server'

Rails.application.routes.draw do
  root to: 'static_pages#home'

  resources :listings, only: %i[index show]
  resources :reservations do
    member do
      post '/cancel' => 'reservations#cancel'
      get '/expire' => 'reservations#expire'
    end
  end
    # resources :webhooks, only: [:create]
  post '/webhooks/:source' => 'webhooks#create'

  namespace :host do
    get 'reservations/show'
    resources :merchant_settings do
      collection do
        get '/connect' => 'merchant_settings#connect'
        get '/connected' => 'merchant_settings#connected'
      end
    end
    resources :listings do
      resources :photos, only: %i[index create destroy new]
      resources :rooms, only: %i[index create destroy] # /host/listings/:listing_id/room/2
    end
    resources :reservations, only: [:show]
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


# get "users/oauth/google/callback", to: "omniauth_callabacks#google_oauth2"
# http://localhost:3000/users/oauth/google/callback