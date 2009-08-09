class PictureSweeper < ActionController::Caching::Sweeper
  observe Picture

  def after_save(record)
    # Delete the jpg and png versions, as well as the html version
    expire_page(:controller => 'pictures', :action => 'show')
  end
end
