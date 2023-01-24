module DragonSkeleton
  module Screen
    class << self
      def with_resolution(x_resolution, y_resolution)
        scale = [1280.idiv(x_resolution), 720.idiv(y_resolution)].min
        w = x_resolution * scale
        h = y_resolution * scale
        {
          x_resolution: x_resolution,
          y_resolution: y_resolution,
          x: (1280 - w).idiv(2),
          y: (720 - h).idiv(2),
          w: w,
          h: h,
          scale: scale
        }
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
    end
  end
end
