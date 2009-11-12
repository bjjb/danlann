ActionController::Routing::Routes.draw do |map|
  map.resources :pictures,
                :member => {
                  :thumbnail => :get,
                  :polaroid => :get,
                  :small => :get,
                  :medium => :get,
                  :large => :get,
                  :full => :get,
                  :rotate_left => :post,
                  :rotate_right => :post,
                  :flip => :post,
                  :crop => :post
                }
  map.resources :tags, :member => { :slideshow => :get }
  map.resources :users,
                :only => [:new, :create],
                :member => { :confirm => :get }
  map.resources :user_sessions, :only => [:new, :create, :destroy]
  map.login 'login', :controller => 'user_sessions', :action => 'new'
  map.logout 'logout', :controller => 'user_sessions', :action => 'destroy'
  map.register 'register', :controller => 'users', :action => 'new'
  map.root :controller => 'tags'
end
