class Picture < ActiveRecord::Base
  has_many :taggings
  has_many :tags, :through => :taggings
  after_save :tag!

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  before_save :crop!

  attr_accessor :rotation
  before_save :rotate!


  attr_accessible :name, :image_file, :description, :tag_names, :public,
    :rotation, :crop_x, :crop_y, :crop_w, :crop_h

  def tag_names
    @tag_names || tags.map(&:name).join(' ')
  end
  
  def tag_names=(string)
    @tag_names = string.downcase
  end

  cattr_accessor :per_page
  @@per_page = 12

  acts_as_fleximage do
    image_directory 'db/files'
    image_storage_format :jpg
  end

  named_scope :latest, lambda {
    { :limit => per_page, :order => 'created_at DESC' }
  }

  named_scope :public, { :conditions => { :public => true } }

  named_scope :viewable_by, lambda { |user|
    {
      :conditions => case user
        when Integer then ['public=? OR user_id=?', true, user]
        when User then ['public=? OR user_id=?', true, user.id]
        else { :public => true }
      end
    }
  }

  def image
    @image ||= Magick::Image.read(file_path).first
  end

private

  def tag!
    unless @tag_names.blank?
      self.tags = @tag_names.split(Tag.separator).map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end

  def crop!
    unless [@crop_x, @crop_y, @crop_h, @crop_w].any?(&:blank?)
      logger.debug "Cropping %s: %d:%d %d×%d" % [
        self.to_s, @crop_x, @crop_y, @crop_w, @crop_h
      ]
      image.crop!(*[@crop_x, @crop_y, @crop_w, @crop_h].map(&:to_i))
      image.write(file_path)
    end
  end

  def rotate!
    unless @rotation.blank? or @rotation.to_i.zero?
      logger.debug "Rotating #{self} by #{@rotation}°"
      image.rotate!(@rotation.to_i)
      image.write(file_path)
      @rotation = 0
    end
  end

  def self.belongs_to_user?
    columns.include?('user_id')
  end

  def self.has_and_belongs_to_many_tags?
    %w(tags pictures_tags).all? { |t| connection.tables.include?(t) }
  end

  def self.has_many_tags_through_taggings?
    %w(tags taggings).all? { |t| connection.tables.include?(t) }
  end
end
