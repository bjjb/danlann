class TagsController < ApplicationController
  cache_sweeper :tag_sweeper, :only => %w(update destroy)

  def index
    @tags = Tag.paginate(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def show
    @tag = Tag.find(params[:id])
    @pictures = @tag.pictures.viewable_by(current_user).paginate(:page => params[:page])
    respond_to do |format|
      format.html # show.html.erb
    end
  end

  def slideshow
    @tag = Tag.find(params[:id])
    respond_to do |format|
      format.js
    end
  end
end
