Rails.application.routes.draw do
  get "logout" => "session#destroy", :as => "logout"
  get "login" => "session#new", :as => "login"
  post "login" => "session#create"
  get "signup" => "users#new", :as => "signup"
  resources :users
  resources :session
  resources :entries
  resources :relations
  root :to => "entries#index"
end
