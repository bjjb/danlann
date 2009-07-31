# The new polaroid Fleximage operator. See, the ImageMagick developers liked
# the Polaroid(c) effect so much that they built it in, so RMagick::Image now
# has a polaroid method. If you pass a string in, it will be used as the
# caption, centered underneath the image.
class Fleximage::Operator::Polaroid < Fleximage::Operator::Base
  def operate(options = {})
    @image['Caption'] = options[:caption] if options.key?(:caption)
    options[:angle] ||= (-5..5).to_a.rand
    @image.polaroid(options[:angle]) do
      self.gravity = Magick::CenterGravity
    end
  end
end
