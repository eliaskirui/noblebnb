Rails.application.routes.draw do
  root to: 'static_pages#home'
  # get 'listings/index'
  # get 'listings/show'

  resources :listings, only: [:index, :show]
  # get "users/oauth/google/callback", to: "omniauth_callabacks#google_oauth2"

  namespace :host do
    resources :listings do
      resources :photos, only: [:index, :create, :destroy, :new]
      resources :rooms, only: [:index, :create, :destroy] # /host/listings/:listing_id/room/2
    end
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  # devise_for :users,
  #            controllers: {
  #              omniauth_callbacks: "users/omniauth_callbacks",
  #              registrations: "users/registrations",
  #              sessions: "users/sessions"
  #            }
  # devise_scope :user do
  #   get "session/otp", to: "sessions#otp"
  # end

end
