class User < ActiveRecord::Base
  has_many :pictures
  acts_as_authentic
end
