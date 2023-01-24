module DragonSkeleton
  module Pathfinding
    MANHATTAN_DISTANCE = ->(a, b) { (a[:x] - b[:x]).abs + (a[:y] - b[:y]).abs }
  end
end
