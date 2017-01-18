Rails.application.routes.draw do
  root 'static_pages#welcome'

  get '/help',          to: 'static_pages#help'
  get '/about',         to: 'static_pages#about'
  get '/feed',          to: 'activities#feed'
  get '/dashboard',     to: 'activities#dashboard'
  get '/strava_auth',   to: 'sessions#create'
  post '/login',        to: 'sessions#new'
  delete '/logout',     to: 'sessions#destroy'

  match '/404',       to: 'errors#not_found', via: :all
  match '/500',       to: 'errors#internal_server_error', via: :all

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    member do # member associates user id with url (e.g., users/1/following)
      get :following, :followers
    end
  end
  resources :activities, only: [:show, :new, :create, :destroy]
  resources :relationships, only: [:create, :destroy]
end
