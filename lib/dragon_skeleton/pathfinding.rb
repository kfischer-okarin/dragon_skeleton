module DragonSkeleton
  module Pathfinding
    MANHATTAN_DISTANCE = ->(a, b) { (a[:x] - b[:x]).abs + (a[:y] - b[:y]).abs }
    CHEBYSHEV_DISTANCE = ->(a, b) { [(a[:x] - b[:x]).abs, (a[:y] - b[:y]).abs].max }
    EUCLIDEAN_DISTANCE = ->(a, b) { Math.sqrt((a[:x] - b[:x])**2 + (a[:y] - b[:y])**2) }
  end
end
