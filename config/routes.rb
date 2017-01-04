Rails.application.routes.draw do
  root 'static_pages#welcome'

  get '/help',        to: 'static_pages#help'
  get '/about',       to: 'static_pages#about'
  get '/feed',        to: 'static_pages#feed'
  get '/signup',      to: 'users#new'
  get '/strava_auth', to: 'users#strava_auth'
  get '/login',       to: 'sessions#new'
  post '/signup',     to: 'users#create'
  post '/login',      to: 'sessions#create'
  delete '/logout',   to: 'sessions#destroy'

  match '/404',       to: 'errors#not_found', via: :all
  match '/500',       to: 'errors#internal_server_error', via: :all

  resources :users do
    member do # member associates user id with url (e.g., users/1/following)
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :activities, only: [:show, :new, :create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
