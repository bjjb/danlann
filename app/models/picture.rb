class Picture < ActiveRecord::Base
  belongs_to :user

  has_many :taggings, :dependent => :destroy
  has_many :tags, :through => :taggings
  attr_writer :tag_names
  after_save :apply_tags

  acts_as_fleximage do
    image_directory 'db/uploaded'
  end

  def tag_names
    @tag_names || tags.map(&:name)
  end

private
  def apply_tags
    unless @tag_names.blank?
      self.tags = @tag_names.split(Tag.separator).map do |name|
        Tag.find_or_create_by_name(name)
      end
    end
  end
end
