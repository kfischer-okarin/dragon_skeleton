module DragonSkeleton
  module LongCalculation
    # A long calculation that runs over many steps and eventually returns a result.
    module LongCalculationFiber
      def self.extend_object(object) # :nodoc:
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

      # Runs the next step of the calculation.
      def resume
        super unless finished?
      end

      # Returns +true+ if the calculation has finished.
      def finished?
        !result.nil?
      end

      # Runs the calculation until it finishes.
      def finish
        resume until finished?
      end

      # Runs the calculation until it finishes or the given amount of milliseconds has passed.
      #
      # This is useful for spreading the calculation over multiple ticks.
      def run_for_ms(milliseconds)
        start_time = Time.now.to_f
        resume until finished? || (Time.now.to_f - start_time) * 1000 >= milliseconds
      end

      ##
      # :attr_accessor: result
      # The result of the calculation or +nil+ if the calculation has not finished yet.
    end
  end
end
