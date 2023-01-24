module DragonSkeleton
  module Screen
    class << self
      def with_resolution(x_resolution, y_resolution = nil)
        {
          x_resolution: x_resolution,
          y_resolution: y_resolution || 720.idiv(1280.idiv(x_resolution))
        }
      end

      def build_render_target(args, screen)
        result = args.outputs[:screen]
        result.width = screen[:x_resolution]
        result.height = screen[:y_resolution]
        result
      end
    end
  end
end
