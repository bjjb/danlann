class Batch < ActiveRecord::Base
  belongs_to :user

  has_many :batch_memberships
  has_many :pictures, :through => :batch_memberships

  attr_writer :tag_names
  
  def tag_names
    @tag_names ||= pictures.map(&:tag_names).inject { |m, a| m & a }
  end

  validates_presence_of :name
  validates_uniqueness_of :name, :scope => :user_id

  validates_presence_of :user_id
end
