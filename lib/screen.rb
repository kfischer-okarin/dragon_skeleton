# Contains methods for working with a low-resolution screen.
#
# First, you need to create a screen object via ::with_resolution.
#
#   screen = Screen.with_resolution(320, 180)
#
# Then you must prepare render target with ::build_render_target to draw to the screen.
#
#   render_target = Screen.build_render_target(args, screen)
#   render_target.primitives << { x: 20, y: 20, w: 32, h: 32, path: 'character.png' }.sprite!
#
# Finally, you need to draw the screen to the main render area using ::sprite.
#
#   args.outputs.primitives << Screen.sprite(screen)
module Screen
  class << self
    # Creates a screen object with the given resolution.
    #
    # The scale of the screen (2 for example meaning the screen is rendered at
    # double size) is automatically calculated from the resolution to fit into
    # 1280x720.
    #
    # The position of the screen is automatically calculated to be centered on the
    # display.
    #
    # Both the scale and position can be overridden via the +scale+ and
    # +render_position+ keyword arguments.
    def with_resolution(x_resolution, y_resolution, scale: nil, render_position: nil)
      scale ||= [1280.idiv(x_resolution), 720.idiv(y_resolution)].min
      w = x_resolution * scale
      h = y_resolution * scale
      render_position ||= { x: (1280 - w).idiv(2), y: (720 - h).idiv(2) }
      render_position.merge(
        x_resolution: x_resolution,
        y_resolution: y_resolution,
        w: w,
        h: h,
        scale: scale
      )
    end

    # Creates a render target used to render to the given screen.
    def build_render_target(args, screen)
      result = args.outputs[:screen]
      result.width = screen[:x_resolution]
      result.height = screen[:y_resolution]
      result.transient!
      result
    end

    # Creates a sprite that is used to draw the given screen to the display.
    def sprite(screen)
      screen.slice(:x, :y, :w, :h).sprite!(path: :screen)
    end

    # Converts a display position to coordinates on the given screen.
    def to_screen_position(screen, position)
      {
        x: (position.x - screen[:x]).idiv(screen[:scale]),
        y: (position.y - screen[:y]).idiv(screen[:scale])
      }
    end

    # Returns the rectangle on the display where the pixel at the given screen
    # position is drawn.
    def pixel_rect(screen, screen_position)
      {
        x: screen[:x] + (screen_position.x * screen[:scale]),
        y: screen[:y] + (screen_position.y * screen[:scale]),
        w: screen[:scale],
        h: screen[:scale]
      }
    end
  end

  # 64x64
  LOWREZJAM = with_resolution(64, 64)
  # 84x48
  NOKIA_3310 = with_resolution(84, 48)
  # 427x240
  SNES_STYLE = with_resolution(427, 240)
  # 320x180
  GBA_STYLE = with_resolution(320, 180)
end
