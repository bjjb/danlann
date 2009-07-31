ActionController::Routing::Routes.draw do |map|
  map.resources :roles

  # /pictures/123
  map.resources :pictures

  # /tags/123
  map.resources :tags do |tag|
    # /tags/123/pictures/123
    tag.resources :pictures, :shallow => true
  end

  # /users/123
  map.resources :users do |user|
    # /users/123/pictures/123
    user.resources :pictures, :shallow => true
    # /users/123/tags/123
    user.resources :tags, :shallow => true do |tag|
      # /users/123/tags/123/pictures/123
      tag.resources :pictures, :shallow => true
    end
  end

  map.resources :user_sessions

  # /stylesheets/123
  map.resources :stylesheets

  # /javascripts/123
  map.resources :javascripts

  map.root :controller => 'pictures'
end
