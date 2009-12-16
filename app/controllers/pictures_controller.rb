class PicturesController < ApplicationController
  def self.versions
    %w(thumbnail polaroid small medium large full)
  end

  caches_page *versions

  cache_sweeper :picture_sweeper, :only => %w(create update destroy rotate_left rotate_right flip crop)

  # GET /pictures
  def index
    @pictures = Picture.latest
    respond_to do |format|
      format.html
      format.xml { render :xml => @pictures }
      format.js
    end
  end

  # GET /pictures/1
  def show
    @picture = Picture.find(params[:id])
    respond_to do |format|
      format.html do
        logger.info "Hit me"
      end
      format.xml { render :xml => @picture }
      format.jpg
    end
  end

  # GET /pictures/new
  def new
    @picture = Picture.new

    respond_to do |format|
      format.html
      format.xml { render :xml => @picture }
    end
  end

  # GET /pictures/1/edit
  def edit
    @picture = Picture.find(params[:id])
    respond_to do |format|
      format.html
    end
  end

  # POST /pictures
  def create
    @picture = Picture.new(params[:picture])
    respond_to do |format|
      if @picture.save
        format.html do
          flash[:notice] = "Picture saved"
          redirect_to @picture
        end
        format.xml do
          render :xml => @picture, :status => :created, :location => @picture
        end
      else
        format.html { render :action => "new" }
        format.xml do
          render :xml => @picture.errors, :status => :unprocessable_entity
        end
      end
    end
  end

  # PUT /pictures/1
  def update
    @picture = Picture.find(params[:id])
    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        format.html do
          flash[:notice] = 'Picture saved'
          redirect_to @picture
        end
        format.xml { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml do
          render :xml => @picture.errors, :status => :unprocessable_entity
        end
      end
    end
  end

  # DELETE /pictures/1
  def destroy
    @picture = Picture.find(params[:id])
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_path }
      format.xml { head :ok }
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

  versions.each do |v|
    define_method(v) do
      @picture = Picture.find(params[:id])
      respond_to do |format|
        format.jpg
      end
    end
  end

private
  def rotate(angle)
    @picture = Picture.find(params[:id])
    @picture.rotation = angle
    @picture.save
    respond_to do |format|
      format.html do
        flash[:notice] = "Picture rotated by #{angle}°"
        redirect_to @picture
      end
      format.xml { head :ok }
    end
  end
end
