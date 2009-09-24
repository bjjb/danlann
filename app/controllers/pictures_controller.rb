class PicturesController < ApplicationController
  caches_page :show
  cache_sweeper :picture_sweeper, :only => %w(update destroy)
  cache_sweeper :tag_sweeper, :only => %w(create update destroy)

  before_filter :require_user, :except => [:index, :show]
  before_filter :check_for_zipfile, :only => :create

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
    respond_to do |format|
      if @picture.save
        flash[:notice] = "Your picture has been saved"
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
  def check_for_zipfile
    if `file #{params[:picture][:image_file].path}`.strip =~ /Zip/
      return prepare_pictures_from_zipfile
    else
      true
    end
  end

  # Unpacks the zipfile, and starts the rake task to import them in the
  # background. TODO - move this logic into a module, and make cross-platform
  def prepare_pictures_from_zipfile
    dir = File.join(
      Rails.root,
      Picture.image_directory,
      Time.now.strftime('%Y/%m/%d')
    )
    zipfile = params[:picture][:image_file].path
    tmpdir = File.join(
      Rails.root,
      "tmp/unpacked",
      File.basename(zipfile)
    )
    system "mkdir -p '#{tmpdir}'"
    system "unzip -jo -d '#{tmpdir}' '#{zipfile}'"
    File.open("#{tmpdir}/meta.yml", 'w') do |f|
      meta = params[:picture].clone
      meta.delete(:image_file)
      meta.reject! { |k, v| v.blank? }
      meta.merge!(:user_id => current_user.id)
      YAML.dump(meta, f)
    end
    system "rake import_unpacked RAILS_ENV=#{Rails.env} &"
    flash[:notice] = "Your images have been unpacked, and will be "   <<
      "available as soon as they have been imported. Try refreshing " <<
      "the page in a few minutes."
    redirect_to pictures_url
    false # Stop processing
  rescue Zip::ZipError
    true # Keep processing
  end
end
