class User < ActiveRecord::Base
  has_many :pictures

  has_many :taggings
  has_many :tags, :through => :taggings

  has_and_belongs_to_many :roles
  attr_writer :role_names
  after_save :assign_roles

  acts_as_authentic

  def role_names
    @role_names || roles.map { |r| r.name }.join(', ')
  end

  def gravatar_url
    "http://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(email.strip.downcase)}.jpg"
  end

  def assign_roles
    unless @role_names.blank?
      self.roles = @role_names.split(Tag.separator).map do |name|
        Role.find_or_create_by_name(name)
      end
    end
  end

  def method_missing(name, *args, &block)
    if name.to_s =~ /\?$/ and role_names.include?($`)
      return true
    end
    super
  end
end
