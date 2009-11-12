module TagsHelper
  # For all tags, 
  def tag_cloud(options = {})
    options.reverse_merge!(
      :range => 1..5,
      :excluding => lambda { |t| t.pictures.size == 0 },
      :sort => lambda { |t| t.name.downcase },
      :weight => lambda { |t| t.pictures.size }
    )
    tags = Tag.all(:include => :pictures)
    tags.reject!(&options[:excluding])
    sizes = tags.map(&options[:weight]).uniq.sort
    min, max = sizes.min, sizes.max
    delta = max - min
    tags.sort_by(&options[:sort]).each do |tag|
      popularity = if tag.pictures.size > min
        (options[:range].max * (tag.pictures.size - min)) / delta
      else
        options[:range].min
      end
      yield tag, popularity
    end
  end
end
