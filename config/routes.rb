ActionController::Routing::Routes.draw do |map|  map.resources :pictures
  map.resources :tags
  map.resources :users
  map.resource :account
  map.resources :user_sessions
  map.resources :account_confirmations
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.register 'register', :controller => 'users', :action => 'new'
  map.root :controller => 'pictures'
end
