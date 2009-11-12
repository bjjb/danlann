config.cache_classes = true
config.action_controller.consider_all_requests_local = false
config.action_controller.perform_caching             = true
config.action_view.cache_template_loading            = true
if File.exists?(f = File.join(Rails.root, "config", "smtp_settings.yml"))
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = YAML.load(File.read(f))
end
