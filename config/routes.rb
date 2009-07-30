ActionController::Routing::Routes.draw do |map|
  map.resources :tags
  map.resources :pictures, :member => { :thumb => :get, :small => :get }
  map.resources :users
  map.resources :stylesheets
  map.resources :javascripts
end
