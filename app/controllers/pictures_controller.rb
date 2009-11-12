class PicturesController < ApplicationController
  def self.versions
    Dir['app/views/pictures/*.jpg.flexi'].map do |f|
      File.basename(f, '.jpg.flexi')
    end
  end

  caches_page *versions

  cache_sweeper :picture_sweeper, :only => %w(update destroy rotate_left rotate_right flip crop)
  cache_sweeper :tag_sweeper, :only => %w(create update destroy)

  before_filter :require_user, :only => %w(new create edit update destroy)
  
  before_filter :find_picture, :only => [:show, versions].flatten

  # GET /pictures
  def index
    @pictures = Picture.viewable_by(current_user).paginate(
      :page => params[:page]
    )
    respond_to do |format|
      format.html
    end
  end

  # GET /pictures/1
  def show
    respond_to do |format|
      format.html
    end
  end

  # GET /pictures/new
  def new
    @picture = current_user.pictures.new

    respond_to do |format|
      format.html
    end
  end

  # GET /pictures/1/edit
  def edit
    @picture = current_user.pictures.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # POST /pictures
  def create
    @picture = current_user.pictures.new(params[:picture])
    respond_to do |format|
      if @picture.save
        flash[:notice] = "Picture saved"
        format.html { redirect_to @picture }
      else
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /pictures/1
  def update
    @picture = current_user.pictures.find(params[:id])
    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        flash[:notice] = 'Picture saved'
        format.html { redirect_to @picture }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /pictures/1
  def destroy
    @picture = current_user.pictures.find(params[:id])
    if @picture.destroy
      flash[:notice] = 'Picture deleted'
      respond_to do |format|
        format.html { render :action => 'index' }
      end
    end
  end

  def rotate_left
    rotate(-90)
  end

  def rotate_right
    rotate(90)
  end

  def flip
    rotate(180)
  end

  def slideshow
    @pictures = Picture.viewable_by(current_user).all(:select => :id)
  end

  versions.each { |v| define_method(v) { respond_to { |f| f.jpg } } }

private
  def rotate(angle)
    @picture = current_user.pictures.find(params[:id])
    @picture.rotation = angle
    @picture.save
    respond_to do |format|
      flash[:notice] = "Picture rotated by #{angle}°"
      format.html { redirect_to @picture }
    end
  end

  def find_picture
    @picture = Picture.viewable_by(current_user).find(params[:id])
  end
end
