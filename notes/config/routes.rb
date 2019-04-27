Rails.application.routes.draw do
  get 'friends/index'
  get 'friends/destroy'
  resources :friend_requests
  get 'session/new'
  get 'session/create'
  get 'session/destroy'
  get 'notes/index'
  get 'users/index'

  get "logout" => "session#destroy", :as => "logout"
  get "login" => "session#index", :as => "login"
  post "login" => "session#create"
  get "signup" => "users#new", :as => "signup"
  post "friend_requests" => "friend_requests#create"
  post "friends/create" => "friends#create"

  resources :notes
  resources :users
  resources :session
  root 'notes#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
