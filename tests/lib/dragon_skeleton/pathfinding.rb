DragonSkeleton.add_to_top_level_namespace

def test_pathfinding_manhattan_distance(_args, assert)
  distance = Pathfinding::MANHATTAN_DISTANCE.call({ x: 1, y: 1 }, { x: 3, y: 3 })

  assert.equal! distance, 4
end

def test_pathfinding_chebyshev_distance(_args, assert)
  distance = Pathfinding::CHEBYSHEV_DISTANCE.call({ x: 1, y: 1 }, { x: 3, y: 3 })

  assert.equal! distance, 2
end

def test_pathfinding_euclidean_distance(_args, assert)
  distance = Pathfinding::EUCLIDEAN_DISTANCE.call({ x: 1, y: 1 }, { x: 4, y: 5 })

  assert.equal! distance, 5
end
