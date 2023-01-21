module DragonSkeleton
  module LongCalculation
    class << self
      attr_accessor :current_calculation

      def define
        fiber = Fiber.new do
          self.current_calculation = Fiber.current
          result = yield
          Fiber.current.result = result
          self.current_calculation = nil
          Fiber.yield result
        end
        add_additional_methods fiber
        fiber
      end

      def finish_step
        return unless current_calculation

        Fiber.yield
      end

      private

      def add_additional_methods(fiber)
        state = {}
        fiber.define_singleton_method :result do
          state[:result]
        end
        fiber.define_singleton_method :result= do |value|
          state[:result] = value
        end
      end
    end
  end
end
