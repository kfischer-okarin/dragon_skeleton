module DragonSkeleton
  module LongCalculation
    class << self
      def define
        fiber = Fiber.new do
          result = yield
          Fiber.current.result = result
        end
        fiber.extend LongCalculationFiber
        fiber
      end

      def finish_step
        return unless inside_calculation?

        Fiber.yield
      end

      def inside_calculation?
        Fiber.current.respond_to? :result
      end
    end
  end
end
