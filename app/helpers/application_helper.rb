module ApplicationHelper
  def flash_messages
    flash.map do |type, message|
      content_tag('p', :class => [:flash, type]) { message }
    end.join
  end

  def title(*args)
    if args.empty?
      h([yield(:title), self.title].compact.join(title_separator))
    else
      self.title = *args
    end
  end

  def title=(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end
  
  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end
  
  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end
end
