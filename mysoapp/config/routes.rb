Rails.application.routes.draw do
  get "logout" => "session#destroy", :as => "logout"
  get "login" => "session#new", :as => "login"
  post "login" => "session#create"
  get "signup" => "users#new", :as => "signup"
  get "like/:id" => "entries#like", :as => "like"
  get "unlike/:id" => "entries#unlike", :as => "unlike"
  get "share/:id" => "entries#share", :as => "share"
  get "myfriends" => "relations#index", :as => "myfriends"
  get "sendQuery/:id" => "relations#query", :as => "sendQuery"
  get "accept/:id" => "relations#accept", :as => "accept"
  get "revoke/:id" => "relations#destroy", :as => "revoke"
  get "deny/:id" => "relations#deny", :as => "deny"
  get "users" => "users#index", :as => "users"
  resources :users
  resources :session
  resources :entries
  resources :relations
  root :to => "entries#index"
end
