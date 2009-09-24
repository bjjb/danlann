class Tag < ActiveRecord::Base
  has_and_belongs_to_many :pictures

  class << self
    attr_accessor_with_default :separator, /\s*[, ]\s*/
  end
  attr_accessor_with_default :separator, separator
end
