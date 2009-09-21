class ZipFile
  attr_accessor_with_default :description, "No description"
  attr_accessor_with_default :basename, "Image"
  attr_accessor_with_default :public, true
  attr_accessor :tag_names

  # Make a new Archive - this copies the data in filename into a safe
  # temporary file, and opens that file.
  def initialize(path, user)
    @zipfile_path = path
    @user = user
    @exdir = @zipfile_path + "-exdir"
  end

  # Extract the images for import
  def extract
    if Dir.mkdir(@exdir) == 0
      system "unzip #{@zipfile_path} -d #{@exdir}"
    end
  end

  # Import the images into the application. The user *must* be set at this
  # point.
  def import
    raise ArgumentError, "user must be set before import" if @user.nil?
    picturefiles = Dir["#{@exdir}/**/*.{jpg,JPG,png,PNG}"]
    picturefiles.each_with_index do |filename, i|
      File.open(filename) do |file|
        name = if basename
          "%s-%0#{picturefiles.count.to_s.size}d" % [basename, i + 1]
        else
          File.basename(File.path, File.extname(File.path))
        end
        attrs = {
          :name => name,
          :description => description,
          :public => true,
          :image_file => file,
          :public => @public
        }
        def file.original_filename
          File.basename(path) # Behave like an ActiveSupport::UploadedFile
        end
        logger.debug("Creating image: #{attrs.inspect}")
        t = Time.now
        x = @user.pictures.build(attrs)
        logger.debug("Saving image: #{x}")
        x.save!
        logger.debug("Image #{x.id} created (#{Time.now - t} s)")
      end
    end
    cleanup
  end

  # Deletes the temporary directory that was created for the extraction
  def cleanup
    if File.exists?(@exdir)
      system `rm -rf #{@exdir}`
    end
  end

  def logger
    Rails.logger
  end
end
