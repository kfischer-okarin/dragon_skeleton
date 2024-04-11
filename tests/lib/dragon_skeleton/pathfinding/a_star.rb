DragonSkeleton.add_to_top_level_namespace

def test_pathfinding_a_star(_args, assert)
  graph = PathfindingTestHelper.build_graph <<~GRID
    5 1 1 1 1
    5 2 5 5 5
    1 1 1 1 1
  GRID
  pathfinder = Pathfinding::AStar.new(graph, heuristic: Pathfinding::MANHATTAN_DISTANCE)

  assert.equal! pathfinder.find_path({ x: 0, y: 0 }, { x: 4, y: 2 }), [
    { x: 0, y: 0 },
    { x: 1, y: 0 },
    { x: 1, y: 1 },
    { x: 1, y: 2 },
    { x: 2, y: 2 },
    { x: 3, y: 2 },
    { x: 4, y: 2 }
  ]
end

def test_pathfinding_a_star_start_and_goal_is_same(_args, assert)
  graph = PathfindingTestHelper.build_graph <<~GRID
    5 1
  GRID
  pathfinder = Pathfinding::AStar.new(graph, heuristic: Pathfinding::MANHATTAN_DISTANCE)

  assert.equal! pathfinder.find_path({ x: 0, y: 0 }, { x: 0, y: 0 }), [{ x: 0, y: 0 }]
end

def test_pathfinding_a_star_no_path(_args, assert)
  graph = { a: [{ to: :b, cost: 1 }], b: [{ to: :a, cost: 1 }], c: [] }
  pathfinder = Pathfinding::AStar.new(graph, heuristic: ->(_, _) { 0 })

  assert.equal! pathfinder.find_path(:a, :c), []
end

module PathfindingTestHelper
  class << self
    def build_graph(string)
      grid = string.split("\n").reverse.map_with_index do |line, y|
        line.split.map_with_index do |char, x|
          { x: x, y: y, cost: char.to_i }
        end
      end

      graph = {}

      grid.each_with_index do |row, y|
        row.each_with_index do |_, x|
          position = { x: x, y: y }
          graph[position] = []

          [[0, 1], [1, 0], [0, -1], [-1, 0]].each do |(dx, dy)|
            neighbor = { x: x + dx, y: y + dy }
            next unless grid[neighbor[:y]]&.[](neighbor[:x])

            graph[position] << { to: neighbor, cost: grid[neighbor[:y]][neighbor[:x]][:cost] }
          end
        end
      end

      graph
    end
  end
end
