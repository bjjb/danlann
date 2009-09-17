RAILS_GEM_VERSION = '2.3.4' unless defined? RAILS_GEM_VERSION

require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  config.time_zone = 'UTC'

  config.gem  'rmagick', :lib => 'RMagick'
  config.gem  'authlogic'
  config.gem  'ruby-openid', :lib => 'openid'
  config.gem  'authlogic-oid', :lib => 'authlogic_openid'
  config.gem  'mislav-will_paginate',
              :lib => 'will_paginate',
              :source => 'http://gems.github.com'
  config.gem  'bluecloth'
  config.gem  'rubyzip', :lib => 'zip/zipfilesystem'

  # Load your own config/session.yml - which should *not* be checked in!
  if File.exists?(f = File.join(Rails.root, "config", "session.yml"))
    config.action_controller.session = YAML.load(File.read(f))
  end

  config.after_initialize do
    ActionView::Base.default_form_builder = LabeledFormBuilder
  end
end
