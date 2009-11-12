class Tag < ActiveRecord::Base
  has_and_belongs_to_many :pictures

  validates_presence_of :name
  before_save :downcase

  class << self
    attr_accessor_with_default :separator, /\s*[, ]\s*/
  end
  attr_accessor_with_default :separator, separator

private
  def downcase
    self.name.downcase! if self.name.respond_to?(:downcase)
  end
end
