DragonSkeleton.add_to_top_level_namespace

def test_priority_queue(_args, assert)
  queue = Pathfinding::PriorityQueue.new
  queue.insert :five, 5
  queue.insert :four, 4
  queue.insert :twelve, 12
  queue.insert :one, 1
  queue.insert :twentytwo, 22

  elements = []
  elements << queue.pop until queue.empty?

  assert.equal! elements, %i[one four five twelve twentytwo]
end
