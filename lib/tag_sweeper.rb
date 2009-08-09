class TagSweeper < ActionController::Caching::Sweeper
  observe Tag

  def after_save(record)
    %w(jpg png html).each do |format|
      expire_page(:controller => 'tags', :action => 'show', :format => format)
    end
    expire_page(:controller => 'tags', :action => 'index')
  end
end
