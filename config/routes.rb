ActionController::Routing::Routes.draw do |map|
  map.resources :roles

  map.resources :pictures

  map.resources :tags do |tag|
    tag.resources :pictures, :shallow => true
  end

  map.resources :users do |user|
    user.resources :pictures, :shallow => true
    user.resources :tags, :shallow => true do |tag|
      tag.resources :pictures, :shallow => true
    end
  end

  map.resources :user_sessions
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.register 'register', :controller => 'users', :action => 'new'

  map.resources :batches

  map.root :controller => 'welcome'
end
