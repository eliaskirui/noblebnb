Rails.application.routes.draw do
  root to: 'static_pages#home'
  # get 'listings/index'
  # get 'listings/show'

  resources :listings, only: [:index, :show]
  get "users/oauth/google/callback", to: "omniauth_callabacks#google_oauth2"

  namespace :host do
    resources :photos, only: [:index, :create, :destroy]
    resources :listings do
      # /host/listings/:listing_id/room/2
      resources :rooms, only: [:index, :create, :destroy]
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
