class Fleximage::Operator::Polaroid < Fleximage::Operator::Base
  def operate
    @image.border!(10, 10, "#f0f0ff")
    @image.background_color = "none"
    amplitude = @image.columns * 0.01
    wavelength = @image.rows  * 2
    @image.rotate!(90)
    @image = @image.wave(amplitude, wavelength)
    @image.rotate!(-90)
    shadow = @image.flop
    shadow = shadow.colorize(1, 1, 1, "gray50")
    shadow.background_color = "white"
    shadow.border!(5, 5, "white")
    shadow = shadow.blur_image(0, 3)
    @image = shadow.composite(@image, -amplitude/2, 5, Magick::OverCompositeOp)
    @image.rotate!((-4..4).to_a.rand)
    @image.trim!
  end
end
