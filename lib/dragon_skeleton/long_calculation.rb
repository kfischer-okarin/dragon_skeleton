module DragonSkeleton
  module LongCalculation
    class << self

      def define
        fiber = Fiber.new do
          result = yield
          Fiber.current.result = result
          Fiber.yield result
        end
        add_additional_methods fiber
        fiber
      end

      def finish_step
        return unless Fiber.current.respond_to? :result

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
        fiber.define_singleton_method :finish do
          resume while result.nil?
        end
      end
    end
  end
end
