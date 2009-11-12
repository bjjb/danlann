class TagSweeper < ActionController::Caching::Sweeper
  observe Tag

  def after_save(record)
    expire_page(:controller => 'tags', :action => 'index')
    expire_page(:controller => 'tags', :action => 'show', :id => record)
  end
end
