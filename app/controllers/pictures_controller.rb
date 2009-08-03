class PicturesController < ApplicationController

  caches_page :show
  before_filter :search

  # GET /pictures
  def index
    @pictures = Picture.paginate(@conditions)
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @pictures }
    end
  end

  # GET /pictures/1
  def show
    @picture = Picture.find(params[:id])
    respond_to do |format|
      format.html
      format.jpg
      format.png
      format.xml  { render :xml => @picture }
    end
  end

  # GET /pictures/new
  def new
    @picture = Picture.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @picture }
    end
  end

  # GET /pictures/1/edit
  def edit
    @picture = Picture.find(params[:id])
  end

  # POST /pictures
  def create
    @picture = Picture.new(params[:picture])

    respond_to do |format|
      if @picture.save
        flash[:notice] = 'Picture was successfully created.'
        format.html { redirect_to(@picture) }
        format.xml  { render :xml => @picture, :status => :created, :location => @picture }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @picture.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /pictures/1
  def update
    @picture = Picture.find(params[:id])

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
    @picture = Picture.find(params[:id])
    @picture.destroy

    respond_to do |format|
      format.html { redirect_to(pictures_url) }
      format.xml  { head :ok }
    end
  end

private
  def search
    @conditions = {}
    if params[:search]
      @conditions[:joins] = :tags
      @conditions[:conditions] = [
        'pictures.name LIKE ? OR ' +
        'tags.name LIKE ? OR ' +
        'pictures.image_filename LIKE ?',
        "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%"
      ]
    end
    @conditions[:page] = params[:page]
    @conditions[:per_page] = params[:per_page]
  end
end
