# Called when ActionView renders a field for an invalid model attribute
# Renders the error message, and then the field itself in a span.
ActionView::Base.field_error_proc = Proc.new do |html_tag, instance_tag|
  if html_tag =~ /type=["']hidden['"]/ || html_tag =~ /<label/
    html_tag
  else
    '<span class="field_error">%s</span><span class="error_message">%s</span>' %
      [html_tag, [instance_tag.error_message].flatten.first]
  end
end
