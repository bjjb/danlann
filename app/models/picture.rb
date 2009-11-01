class Picture < ActiveRecord::Base
  belongs_to :user
  
  has_and_belongs_to_many :tags
  attr_writer :tag_names
  attr_writer :rotation
  after_save :tag, :rotate

  attr_accessible :name, :description, :tag_names, :rotation

  def tag_names
    @tag_names || tags.map(&:name).join(' ')
  end

  def rotation
    @rotation || 0
  end

  validates_presence_of :user_id
  validates_length_of :name, :within => 2..30
  validates_length_of :description, :maximum => 10000

  class << self
    attr_accessor_with_default :group_size, 6
  end
  attr_accessor_with_default :group_size, group_size

  cattr_accessor :per_page
  @@per_page = 9

  acts_as_fleximage do
    image_directory 'db/files'
    image_storage_format :jpg
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

  def zipfile?
    puts "Hello"
    debugger
    puts "OK"
  end

  def unzip
  puts "yo"
    debugger
    puts "foo"
  end

private

  def tag
    unless @tag_names.blank?
      self.tags = @tag_names.split(Tag.separator).map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end

  def rotate
    unless @rotation.blank? or @rotation.to_i.zero?
      logger.debug("Rotating #{self} by #{@rotation}°")
      image = Magick::Image.read(file_path).first
      image = image.rotate(@rotation.to_i)
      image.write(file_path)
    end
  rescue
    logger.error("Error rotating #{self}: #{$!.message}")
  end
end
