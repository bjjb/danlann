module ApplicationHelper

  attr_writer :title
  def title(*args)
    if args.empty?
      h([yield(:title), self.title].compact.join(title_separator))
    else
      self.title = *args
    end
  end

  def title=(title)
    content_for(:title) { title }
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args.map(&:to_s)) }
  end
  
  def javascript(*args)
    args = args.map { |arg| arg == :defaults ? arg : arg.to_s }
    content_for(:head) { javascript_include_tag(*args) }
  end
end
