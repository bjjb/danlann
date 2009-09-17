ActionController::Routing::Routes.draw do |map|
  map.resources :zipfiles
  map.resources :pictures
  map.resources :batches
  map.resources :tags
  map.resources :users
  map.resources :user_sessions
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.register 'register', :controller => 'users', :action => 'new'
  map.root :controller => 'pictures'
end
