module DragonSkeleton
  # Contains pathfinding algorithms.
  #
  # Graphs are represented as hashes where keys are nodes and values are arrays of edges.
  # Edges are hashes with keys +:to+ and +:cost+. +:to+ is the node the edge
  # leads to and +:cost+ is the cost of traversing the edge.
  #
  # Nodes can be any kind of data, usually coordinates on a grid with additional pathfinding related data.
  #
  # Example:
  #
  #   graph = {
  #     { x: 0, y: 0 } => [
  #       { to: { x: 1, y: 0 }, cost: 1 },
  #       { to: { x: 0, y: 1 }, cost: 1 }
  #     ],
  #     { x: 1, y: 0 } => [
  #       { to: { x: 0, y: 0 }, cost: 1 },
  #       { to: { x: 0, y: 1 }, cost: 1.5 }
  #     ],
  #     { x: 0, y: 1 } => [
  #       { to: { x: 0, y: 0 }, cost: 1 },
  #       { to: { x: 1, y: 0 }, cost: 1.5 }
  #     ]
  #   }
  module Pathfinding
    # Calculates the {Manhattan distance}[https://en.wikipedia.org/wiki/Taxicab_geometry] between the two arguments.
    #
    # The arguments must be hashes with keys +:x+ and +:y+.
    MANHATTAN_DISTANCE = ->(a, b) { (a[:x] - b[:x]).abs + (a[:y] - b[:y]).abs }

    # Calculates the {Chebyshev distance}[https://en.wikipedia.org/wiki/Chebyshev_distance] between the two arguments.
    #
    # The arguments must be hashes with keys +:x+ and +:y+.
    CHEBYSHEV_DISTANCE = ->(a, b) { [(a[:x] - b[:x]).abs, (a[:y] - b[:y]).abs].max }

    # Calculates the {Euclidean distance}[https://en.wikipedia.org/wiki/Euclidean_distance] between the two arguments.
    #
    # The arguments must be hashes with keys +:x+ and +:y+.
    EUCLIDEAN_DISTANCE = ->(a, b) { Math.sqrt((a[:x] - b[:x])**2 + (a[:y] - b[:y])**2) }
  end
end
