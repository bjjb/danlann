class Picture < ActiveRecord::Base
  belongs_to :user
  
  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  attr_writer :tag_names
  after_save :apply_tags

  validates_presence_of :user_id
  validates_length_of :name, :within => 2..30
  validates_length_of :description, :maximum => 10000

  class << self
    attr_accessor_with_default :group_size, 6
  end
  attr_accessor_with_default :group_size, group_size

  cattr_accessor :per_page
  @@per_page = 12

  acts_as_fleximage do
    image_directory 'db/uploaded'
  end

  def tag_names
    @tag_names || tags.map(&:name)
  end

  named_scope :most_recent, lambda { { :limit => group_size, :order => 'created_at DESC' } }

  named_scope :public, { :conditions => { :public => true } }
  named_scope :viewable_by, lambda { |user| { :conditions => 
      case user
        when Integer then ['public=? OR user_id=?', true, user]
        when User then ['public=? OR user_id=?', true, user.id]
        else { :public => true }
      end
    }
  }

private

  def apply_tags
    unless @tag_names.blank?
      self.tags = @tag_names.split(Tag.separator).map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end
end
