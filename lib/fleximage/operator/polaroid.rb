# The new polaroid Fleximage operator. See, the ImageMagick developers liked
# the Polaroid(c) effect so much that they built it in, so RMagick::Image now
# has a polaroid method. If you pass a string in, it will be used as the
# caption, centered underneath the image.
#class Fleximage::Operator::Polaroid < Fleximage::Operator::Base
#  def operate(options = {})
#    @image['Caption'] = options[:caption] if options.key?(:caption)
#    options[:angle] ||= (-5..5).to_a.rand
#    @image.polaroid(options[:angle]) do
#      self.shadow_color = options[:shadow_color] || 'white'
#      self.gravity = Magick::CenterGravity
#    end
#  end
#end

# The old example polaroid operator. Taken from
# http://wiki.github.com/Squeegy/fleximage/customimageoperators
class Fleximage::Operator::Polaroid < Fleximage::Operator::Base
  def operate(options = {})
    @image.border!(10, 10, options[:shadow_colow] || "#f0f0ff")

    # Bend the image
    @image.background_color = "none"

    amplitude = @image.columns * 0.01
    wavelength = @image.rows  * 2

    @image.rotate!(90)
    @image = @image.wave(amplitude, wavelength)
    @image.rotate!(-90)

    # Make the shadow
    shadow = @image.flop
    shadow = shadow.colorize(1, 1, 1, options[:shadow_color] || "gray75")
    shadow.background_color = "#101010"
    shadow.border!(10, 10, "#101010")
    shadow = shadow.blur_image(0, 3)
    @image = shadow.composite(@image, -amplitude/2, 5, Magick::OverCompositeOp)

    @image.rotate!(options[:angle] ||= (-5..5).to_a.rand)
    @image.trim!
  end
end

