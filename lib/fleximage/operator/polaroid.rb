class Fleximage::Operator::Polaroid < Fleximage::Operator::Base
  if Magick::Version =~ /^RMagick 2/ and false
    # The new polaroid Fleximage operator. See, the ImageMagick developers
    # liked the Polaroid™ effect so much that they built it in, so
    # RMagick::Image now has a polaroid method. If you pass a string in, it
    # will be used as the caption, centered underneath the image.
    # Unfortunately, the older method (below) gives nicer looking polaroids.
    def operate(options = {})
      @image.background_color = options[:background_color] || "white"
      @image['Caption'] = options[:caption] if options.key?(:caption)
      options[:angle] ||= (-5..5).to_a.rand
      @image.polaroid(options[:angle]) do
        self.shadow_color = options[:shadow_color] || "gray75"
        self.gravity = Magick::CenterGravity
      end
    end
  else
    # The old example polaroid operator. Taken from
    # http://wiki.github.com/Squeegy/fleximage/customimageoperators
    def operate(options = {})
      options[:background_color] ||= "white"
      options[:border_color] ||= "#f0f0f0"
      options[:shadow_color] ||= "black"

      @image.border!(10, 10, options[:border_color])

      # Bend the image
      @image.background_color = options[:background_color]

      amplitude = @image.columns * 0.01
      wavelength = @image.rows  * 2

      @image.rotate!(90)
      @image = @image.wave(amplitude, wavelength)
      @image.rotate!(-90)

      # Make the shadow
      shadow = @image.flop
      shadow = shadow.colorize(1, 1, 1, options[:shadow_color])
      shadow.background_color = options[:background_color]
      shadow.border!(10, 10, options[:background_color])
      shadow = shadow.blur_image(0, 3)
      @image = shadow.composite(@image, -amplitude/2, 5, Magick::OverCompositeOp)

      @image.rotate!(options[:angle] ||= (-5..5).to_a.rand)
      @image.trim!
    end
  end
end
