module DragonSkeleton
  module Pathfinding
    class AStar
      def initialize(graph, heuristic:)
        @graph = graph
        @heuristic = heuristic
      end

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
end
