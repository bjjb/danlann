class Tagging < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag
  belongs_to :picture
  
  before_validation_on_create :set_user_id

private
  def set_user_id
    self.user_id ||= self.picture.user_id
  end
end
