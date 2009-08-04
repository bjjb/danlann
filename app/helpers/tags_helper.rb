module TagsHelper
  def linearize(tags)
    tags.map { |tag| [1, tag] }
  end
end
