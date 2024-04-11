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
        object.define_singleton_method :yield_strategy do
          state[:yield_strategy]
        end
        object.define_singleton_method :yield_strategy= do |value|
          state[:yield_strategy] = value
        end
        super
      end

      class AlwaysYieldStrategy
        def self.should_yield?
          true
        end
      end

      class NeverYieldStrategy
        def self.should_yield?
          false
        end
      end

      class YieldAfterDurationStrategy
        def initialize(milliseconds)
          @milliseconds = milliseconds
          @start_time = Time.now.to_f
        end

        def should_yield?
          (Time.now.to_f - @start_time) * 1000 >= @milliseconds
        end
      end

      # Runs the next step of the calculation.
      def resume
        return if finished?

        self.yield_strategy ||= AlwaysYieldStrategy
        super
      end

      # Returns +true+ if the calculation has finished.
      def finished?
        !result.nil?
      end

      # Runs the calculation until it finishes.
      def finish
        self.yield_strategy = NeverYieldStrategy
        resume
      end

      # Runs the calculation until it finishes or the given amount of milliseconds has passed.
      #
      # This is useful for spreading the calculation over multiple ticks.
      def run_for_ms(milliseconds)
        self.yield_strategy = YieldAfterDurationStrategy.new(milliseconds)
        resume
      end

      ##
      # :attr_accessor: result
      # The result of the calculation or +nil+ if the calculation has not finished yet.
    end
  end
end
