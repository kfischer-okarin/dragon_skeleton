module Pathfinding
  # Pathfinder using the A* algorithm.
  class AStar
    # Creates a new A* pathfinder with the given graph and heuristic.
    #
    # [graph] The graph to search. See the explanation in Pathfinding for more
    #         details about the data structure.
    # [heuristic] A proc that takes two nodes and returns the heuristic value.
    #             Commonly used distance functions are defined as constants in Pathfinding
    #             (e.g. Pathfinding::MANHATTAN_DISTANCE).
    def initialize(graph, heuristic:)
      @graph = graph
      @heuristic = heuristic
    end

    # Finds a path from the start node to the goal node.
    #
    # Returns an array of nodes that form the path from the start node to the goal node.
    # If no path is found, an empty array is returned.
    def find_path(start, goal)
      frontier = PriorityQueue.new
      came_from = { start => nil }
      cost_so_far = { start => 0 }
      frontier.insert start, 0

      until frontier.empty?
        current = frontier.pop
        break if current == goal

        @graph[current].each do |edge|
          cost_to_neighbor = edge[:cost]
          total_cost_to_neighbor = cost_so_far[current] + cost_to_neighbor
          neighbor = edge[:to]
          next if cost_so_far.include?(neighbor) && cost_so_far[neighbor] <= total_cost_to_neighbor

          heuristic_value = @heuristic.call(neighbor, goal)
          priority = total_cost_to_neighbor + heuristic_value
          frontier.insert neighbor, priority
          came_from[neighbor] = current
          cost_so_far[neighbor] = total_cost_to_neighbor
        end
      end
      return [] unless came_from.key? goal

      result = []
      current = goal
      until current.nil?
        result.unshift current
        current = came_from[current]
      end
      result
    end
  end
end
