class TagsController < ApplicationController
  cache_sweeper :tag_sweeper, :only => %w(update destroy)

  # GET /tags
  # GET /tags.xml
  def index
    @tags = Tag.paginate(:page => params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @tags }
    end
  end

  # GET /tags/1
  # GET /tags/1.xml
  def show
    @tag = Tag.find(params[:id])
    @pictures = @tag.pictures.viewable_by(current_user).paginate(:page => params[:page])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @tag }
      # TODO - Tag montages
    end
  end
end
