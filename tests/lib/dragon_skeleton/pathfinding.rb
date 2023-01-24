DragonSkeleton.add_to_top_level_namespace

def test_pathfinding_manhattan_distance(_args, assert)
  distance = Pathfinding::MANHATTAN_DISTANCE.call({ x: 1, y: 1 }, { x: 3, y: 3 })

  assert.equal! distance, 4
end
