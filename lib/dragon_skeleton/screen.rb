module DragonSkeleton
  module Screen
    class << self
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

      def build_render_target(args, screen)
        result = args.outputs[:screen]
        result.width = screen[:x_resolution]
        result.height = screen[:y_resolution]
        result
      end

      def sprite(screen)
        screen.slice(:x, :y, :w, :h).sprite!(path: :screen)
      end

      def to_screen_position(screen, position)
        {
          x: (position.x - screen[:x]).idiv(screen[:scale]),
          y: (position.y - screen[:y]).idiv(screen[:scale])
        }
      end

      def pixel_rect(screen, screen_position)
        {
          x: screen[:x] + (screen_position.x * screen[:scale]),
          y: screen[:y] + (screen_position.y * screen[:scale]),
          w: screen[:scale],
          h: screen[:scale]
        }
      end
    end
  end
end
