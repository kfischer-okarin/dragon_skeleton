module DragonSkeleton
  module LongCalculation
    class << self
      def define
        Fiber.new do
          result = yield
          Fiber.yield result
        end
      end

      def finish_step
        Fiber.yield
      end
    end
  end
end
