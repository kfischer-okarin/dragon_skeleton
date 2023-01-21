module DragonSkeleton
  module LongCalculation
    class << self
      attr_accessor :current_calculation

      def define
        Fiber.new do
          self.current_calculation = Fiber.current
          result = yield
          self.current_calculation = nil
          Fiber.yield result
        end
      end

      def finish_step
        return unless current_calculation

        Fiber.yield
      end
    end
  end
end
