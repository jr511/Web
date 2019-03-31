Rails.application.routes.draw do
  get 'session/new'
  get 'session/create'
  get 'session/destroy'
  get 'notes/index'
  get 'users/index'

  get "logout" => "session#destroy", :as => "logout"
  get "login" => "session#index", :as => "login"
  post "login" => "session#create"
  get "signup" => "users#new", :as => "signup"

  resources :notes
  resources :users
  resources :session
  root 'users#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
