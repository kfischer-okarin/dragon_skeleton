module DragonSkeleton
  module LongCalculation
    class << self

      def define
        fiber = Fiber.new do
          result = yield
          Fiber.current.result = result
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
        def fiber.resume
          super unless finished?
        end

        def fiber.finished?
          !result.nil?
        end

        def fiber.finish
          resume while result.nil?
        end

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
