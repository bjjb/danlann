class PictureSweeper < ActionController::Caching::Sweeper
  observe Picture

  def after_save(record)
    PicturesController.versions.each do |version|
      expire_page(
        :controller => 'pictures',
        :id => record,
        :action => version,
        :format => :jpg
      )
    end
  end
end
