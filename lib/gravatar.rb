# A tiny http://gravatar.com (Globally Recognizable AVATAR) module
# Mix this into your user model to get free gravatar functionality
module Gravatar
  def gravatar
    @gravatar ||= "#{gravatar_url}?s=#{gravatar_size}"
  end
  
  def self.included(mod) 
    class << mod
      attr_accessor_with_default :gravatar_size, 50
      attr_accessor_with_default :gravatar_field, :email
    end
    mod.attr_accessor_with_default :gravatar_size, 50
  end

private
  def gravatar_url
    "http://www.gravatar.com/avatar/%s.jpg" % [
      Digest::MD5.hexdigest(gravatar_id.to_s.strip.downcase)
    ]
  end

  def gravatar_id
    send self.class.gravatar_field
  end
end
