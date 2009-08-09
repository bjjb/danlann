module Gravatar
  def gravatar_url
    "http://www.gravatar.com/avatar/%s.jpg" % [
      Digest::MD5.hexdigest(email.strip.downcase)
    ]
  end

  def gravatar
    @gravatar ||= "#{gravatar_url}?s=#{gravatar_size}"
  end
  
  def self.included(mod) 
    class << mod
      attr_accessor_with_default :gravatar_size, 50
    end
    mod.attr_accessor_with_default :gravatar_size, 50
  end
end
