class User < ActiveRecord::Base
  # See http://github.com/binarylogic/authlogic
  acts_as_authentic

  include Gravatar

  has_many :pictures

  validates_uniqueness_of :email

  attr_accessible :email, :password, :password_confirmation
end
