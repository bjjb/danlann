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
      return import
    else
      true
    end
  end

  # Unpacks the zipfile, and creates pictures from it.
  def import
    tag_names = params[:picture][:tag_names]
    tmpdir = Dir.mktmpdir(nil, 'tmp')
    format = Picture.image_storage_format.to_s
    zipfile = params[:picture][:image_file].path

    system "mkdir -p '#{tmpdir}'"
    system "unzip -jo -d '#{tmpdir}' '#{zipfile}'"
    files = Dir["#{tmpdir}/*.#{format}"].sort

    pictures = files.map do |file|
      name = File.basename(file, File.extname(file))
      description = if File.exists?(txt = "#{tmpdir}/#{name}.txt")
        File.read(txt)
      else
        params[:picture][:description]
      end
      picture = Picture.new(
        :name => name,
        :description => description,
        :tag_names => tag_names,
        :image_filename => file,
        :image_width => 0,
        :image_height => 0
      )
      picture.save(false) # Skip validation for now
      picture
    end

    dir = Picture.image_directory
    dir << "/#{Time.now.year}"
    dir << "/#{Time.now.month}"
    dir << "/#{Time.now.day}"
    system "mkdir -p #{dir}"
    pictures.each do |picture|
      File.rename(picture.image_filename, "#{dir}/#{picture.id}.#{format}")
    end

    system "rm -rf #{tmpdir}"

    flash[:notice] = "Your images have been uploaded"
    redirect_to pictures_url
    false # Stop processing
  end
end
