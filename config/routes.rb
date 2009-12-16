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
end
