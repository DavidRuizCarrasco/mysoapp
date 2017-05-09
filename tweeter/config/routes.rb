Rails.application.routes.draw do
  get "logout" => "session#destroy", :as => "logout"
  get "login" => "session#new", :as => "login"
  post "login" => "session#create"
  get "signup" => "users#new", :as => "signup"
  get "like/:id" => "entries#like", :as => "like"
  get "unlike/:id" => "entries#unlike", :as => "unlike"
  get "share/:id" => "entries#share", :as => "share"
  resources :users
  resources :session
  resources :entries
  resources :relations
  root :to => "entries#index"
end
