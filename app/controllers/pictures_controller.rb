class PicturesController < ApplicationController
  caches_page :show
  cache_sweeper :picture_sweeper, :only => %w(update destroy)
  cache_sweeper :tag_sweeper, :only => %w(create update destroy)

  before_filter :authorize, :except => [:index, :show]

  # GET /pictures
  def index
    @pictures = Picture.viewable_by(current_user).paginate(:page => params[:page])
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pictures }
    end
  end

  # GET /pictures/1
  def show
    @picture = Picture.viewable_by(current_user).find(params[:id])
    respond_to do |format|
      format.html
      format.jpg
      format.png
      format.xml  { render :xml => @picture }
    end
  end

  # GET /pictures/new
  def new
    @picture = current_user.pictures.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @picture }
    end
  end

  # GET /pictures/1/edit
  def edit
    @picture = current_user.pictures.find(params[:id])
  end

  # POST /pictures
  def create
    @picture = current_user.pictures.new(params[:picture])
    return extract if zipfile?(params[:picture][:image_file])
    respond_to do |format|
      if @picture.save
        flash[:notice] = "Your picture's been saved"
        format.html { redirect_to(@picture) }
        format.xml  { head :ok }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @picture.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pictures/1
  def update
    @picture = current_user.pictures.find(params[:id])

    respond_to do |format|
      if @picture.update_attributes(params[:picture])
        flash[:notice] = 'Picture was successfully updated.'
        format.html { redirect_to(@picture) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @picture.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  def destroy
    @picture = current_user.pictures.find(params[:id])
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to(pictures_url) }
      format.xml  { head :ok }
    end
  end

private
  def zipfile?(file)
    Zip::ZipFile.open(file.path) { |zipfile| }
    true
  rescue
    false
  end

  def extract
    attrs = params[:picture].clone
    zipfile = params[:picture].delete(:image_file).path
    count = 1
    Zip::ZipFile.foreach(zipfile) do |entry|
      file = "#{zipfile}-#{entry.name}"
      entry.extract(file)
      attrs[:name] = "#{params[:picture][:name]}-#{count}"
      logger.debug "X [#{zipfile}] #{entry} => #{attrs[:name]}"
      File.open(file) do |image_file|
        attrs[:image_file] = image_file
        picture = current_user.pictures.new(attrs)
        picture.image_filename = entry.name
        picture.save!
      end
      File.delete(file)
      count += 1
    end
    logger.debug "Extracted #{zipfile}"
    respond_to do |format|
      format.html { redirect_to pictures_path }
      format.xml { head :ok }
    end
  end
end
