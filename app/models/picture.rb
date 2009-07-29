class Picture < ActiveRecord::Base
  acts_as_fleximage do
    image_directory 'db/pictures'
  end
end
