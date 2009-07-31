class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy
  has_many :pictures, :through => :taggings
  has_many :users, :through => :taggings

  class << self
    attr_accessor_with_default :separator, /\s*[,| ]\s*/
  end
  attr_accessor_with_default :separator, separator
end
