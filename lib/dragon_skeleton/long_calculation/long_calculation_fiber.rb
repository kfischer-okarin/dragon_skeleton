module DragonSkeleton
  module LongCalculation
    module LongCalculationFiber
      def self.extend_object(object)
        raise ArgumentError, "Fiber expected, got #{object.class}" unless object.is_a? Fiber

        state = {}
        object.define_singleton_method :result do
          state[:result]
        end
        object.define_singleton_method :result= do |value|
          state[:result] = value
        end
        super
      end

      def resume
        super unless finished?
      end

      def finished?
        !result.nil?
      end

      def finish
        resume until finished?
      end
    end
  end
end
