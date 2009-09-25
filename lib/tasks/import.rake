# TODO - move zip/image logic into a module, and make cross platform
desc "Import pending picture folders from tmp/uploaded directory"
task :import_unpacked => :environment do
  class File #:nodoc
    def self.image?(path)
      `file "#{path}"`.strip.include?("image data")
    end

    # A sensible best-guess title for the file (based on its filename)
    def name
      File.basename(path, File.extname(path)).titleize
    end

    # Looks for a file with the same name as this file, but with an extension
    # of .txt instead, and reads it.
    def description
      File.read(desc) if File.exists?(desc = name + ".txt")
    end

    # Makes a File look like an ActiveRecord::UploadedFile.
    def original_filename
      path
    end
  end

  # Loop through all directories in tmp/unpacked...
  Dir["#{Rails.root}/tmp/unpacked/*"].each do |dir|
    next unless File.directory?(dir)
    begin
      # Read the attributes from meta.yml
      meta = YAML.load(File.read("#{dir}/meta.yml"))
      index = 1 # Name sequence
      Dir["#{dir}/*"].each do |file|
        next unless File.image?(file) # Skip this if it's not an image
        # Come up with the next sequential name for the image
        File.open(file) do |f|
          attrs = {}
          begin
            if meta['name'].blank?
              attrs['name'] = f.name
            else
              attrs['name'] = "%s (%d)" % [meta['name'], index]
            end
            if meta['description'].blank?
              attrs['description'] ||= f.description
            else
              attrs['description'] = meta['description']
            end
            attrs['tag_names'] = meta['tag_names']
            attrs['user_id'] = meta['user_id']
            attrs['image_file'] = f
            Picture.create!(attrs)
            index += 1
          rescue
            puts "Error processing file #{file}: #{$!.message}"
          end
        end
      end
      # Finally, delete the image once we're finished with it
      system "rm -fr '#{dir}'"
    rescue
      puts "Error processing directory #{dir}: #{$!.message}"
    end
  end
end
