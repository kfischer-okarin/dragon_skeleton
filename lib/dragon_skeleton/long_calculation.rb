module DragonSkeleton
  # Contains methods for defining and running long calculations that can be spread over multiple ticks.
  #
  # Define a calculation with the LongCalculation.define method.
  #
  #   calculation = LongCalculation.define do
  #     result = 0
  #     1_000_000.times do |i|
  #       result += compute_something(i)
  #       LongCalculation.finish_step
  #     end
  #     result
  #   end
  #
  # It will be interrupted every time the LongCalculation.finish_step method is called during the calculation
  # and will be resumed the next time the LongCalculationFiber#resume method is called on the calculation.
  #
  #   calculation.resume
  #
  # Once finished, the result can be accessed with the LongCalculationFiber#result method.
  #
  #   result = calculation.result
  #
  # The calculation can also be run completely with the LongCalculationFiber#finish method. Or to run as many
  # steps as possible in a given amount of milliseconds, use the LongCalculationFiber#run_for_ms method.
  module LongCalculation
    class << self
      # Define a long calculation with many steps and returns it as a
      # LongCalculationFiber.
      def define
        fiber = Fiber.new do
          result = yield
          Fiber.current.result = result
        end
        fiber.extend LongCalculationFiber
        fiber
      end

      # Call this inside a long calculation to signify that one step of the calculation
      # has finished.
      #
      # The calculation will be resumed the next time the
      # LongCalculationFiber#resume method is called on the calculation.
      def finish_step
        return unless inside_calculation?

        Fiber.yield
      end

      # Returns +true+ if the current code is running inside a long calculation.
      def inside_calculation?
        Fiber.current.respond_to? :result
      end
    end
  end
end
