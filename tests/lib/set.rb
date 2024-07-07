def test_set_union(_args, assert)
  assert.equal! Set[1, 2, 3] | Set[2, 3, 4], Set[1, 2, 3, 4]
  assert.equal! Set[1, 2, 3].union(Set[4, 5, 6]), Set[1, 2, 3, 4, 5, 6]
  assert.equal! Set[1] + Set[2], Set[1, 2]
end

def test_set_intersection(_args, assert)
  assert.equal! Set[1, 2, 3] & Set[2, 3, 4], Set[2, 3]
  assert.equal! Set[1, 2, 3].intersection(Set[4, 5, 6]), Set[]
end

def test_set_difference(_args, assert)
  assert.equal! Set[1, 2, 3] - Set[2, 3, 4], Set[1]
  assert.equal! Set[1, 2, 3].difference(Set[4, 5, 6]), Set[1, 2, 3]
end

def test_set_exclusive_elements(_args, assert)
  assert.equal! Set[1, 2, 3] ^ Set[2, 3, 4], Set[1, 4]
end

def test_set_comparison(_args, assert)
  assert.equal! Set[1, 2] <=> Set[1, 2], 0
  assert.equal! Set[1, 2] <=> Set[1, 3], nil
  assert.equal! Set[1, 2] <=> 22, nil
  assert.equal! Set[1, 2] <=> Set[1, 2, 3], -1
  assert.equal! Set[1, 2, 3] <=> Set[1, 2], 1
end

def test_set_equality(_args, assert)
  set1 = Set[1, 2]
  set2 = Set[1, 2]
  set3 = Set[1, 3]

  assert.equal! set1, set2
  assert.not_equal! set1, set3
end

def test_set_size(_args, assert)
  set = Set[1, 2]

  assert.equal! set.size, 2
  assert.equal! set.length, 2
end

def test_set_empty?(_args, assert)
  set = Set[1, 2]

  assert.false! set.empty?
  assert.true! Set[].empty?
end

def test_set_include?(_args, assert)
  set = Set[1, 2]

  assert.true! set.include?(1)
  assert.false! set.member?(3)
end

def test_set_case_statement(_args, assert)
  value = 1

  case value
  when Set[1, 2]
    assert.ok!
  else
    raise 'Should have matched'
  end
end

def test_set_subset?(_args, assert)
  assert.true! Set[1, 2].subset?(Set[1, 2, 3, 4])
  assert.true!(Set[1, 2] <= Set[1, 2])
  assert.false! Set[1, 2].subset?(Set[1, 3])
end

def test_set_proper_subset?(_args, assert)
  assert.true! Set[1, 2].proper_subset?(Set[1, 2, 3, 4])
  assert.false!(Set[1, 2] < Set[1, 2])
  assert.false!(Set[1, 2] < Set[1, 3])
end

def test_set_superset?(_args, assert)
  assert.true! Set[1, 2, 3, 4].superset?(Set[1, 2])
  assert.true!(Set[1, 2] >= Set[1, 2])
  assert.false! Set[1, 2].superset?(Set[1, 3])
  assert.false!(Set[1] >= Set[1, 3])
end

def test_set_proper_superset?(_args, assert)
  assert.true! Set[1, 2, 3, 4].proper_superset?(Set[1, 2])
  assert.false!(Set[1, 2] > Set[1, 2])
  assert.false!(Set[1, 2] > Set[1, 3])
end

def test_set_disjoint?(_args, assert)
  set = Set[1, 2]

  assert.false! set.disjoint?(Set[1, 2, 3, 4])
  assert.true! set.disjoint?(Set[3, 4])
end

def test_set_intersect?(_args, assert)
  set = Set[1, 2]

  assert.true! set.intersect?(Set[1, 2, 3, 4])
  assert.false! set.intersect?(Set[3, 4])
end

def test_set_add(_args, assert)
  set = Set[1, 2]
  set << 3
  set.add 2

  assert.equal! set, Set[1, 2, 3]
  assert.equal! set.add(4).object_id, set.object_id
end

def test_set_add?(_args, assert)
  set = Set[1, 2]
  assert.equal! set.add?(3), set
  assert.equal! set, Set[1, 2, 3]
  assert.equal! set.add?(2), nil
end

def test_set_merge(_args, assert)
  set = Set[1, 2]
  set.merge([3, 4])

  assert.equal! set, Set[1, 2, 3, 4]
  assert.equal! set.merge([3, 4]).object_id, set.object_id
end

def test_set_replace(_args, assert)
  set = Set[1, 2, 3]
  set.replace [4, 5, 6]

  assert.equal! set, Set[4, 5, 6]
  assert.equal! set.replace([7, 8, 9]).object_id, set.object_id
end

def test_set_clear(_args, assert)
  set = Set[1, 2]
  set.clear

  assert.equal! set, Set[]
end

def test_set_delete(_args, assert)
  set = Set[1, 2]
  set.delete 2

  assert.equal! set, Set[1]
  assert.equal! set.delete(1).object_id, set.object_id
end

def test_set_delete?(_args, assert)
  set = Set[1, 2]
  assert.equal! set.delete?(2), set
  assert.equal! set, Set[1]
  assert.equal! set.delete?(2), nil
end

def test_set_subtract(_args, assert)
  set = Set[1, 2]
  set.subtract([2, 3])

  assert.equal! set, Set[1]
  assert.equal! set.subtract([2, 3]).object_id, set.object_id
end

def test_set_delete_if(_args, assert)
  set = Set[1, 2, 3]
  return_value = set.delete_if { |element| element > 1 }

  assert.equal! set, Set[1]
  assert.equal! return_value.object_id, set.object_id
  assert.equal! set.delete_if.class, Enumerator
end

def test_set_filter!(_args, assert)
  set = Set[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  return_value = set.filter!(&:even?)

  assert.equal! set, Set[2, 4, 6, 8, 10]
  assert.equal! set.object_id, return_value.object_id

  set.select! { |item| item > 4 }

  assert.equal! set, Set[6, 8, 10]
  assert.nil!(set.select! { |item| item > 4 })
  assert.equal! set, Set[6, 8, 10]
end

def test_set_keep_if(_args, assert)
  set = Set[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  return_value = set.keep_if(&:even?)

  assert.equal! set, Set[2, 4, 6, 8, 10]
  assert.equal! set.object_id, return_value.object_id

  set.keep_if { |item| item > 4 }

  assert.equal! set, Set[6, 8, 10]
end

def test_set_reject!(_args, assert)
  set = Set[1, 2, 3]
  return_value = set.reject! { |element| element > 1 }

  assert.equal! set, Set[1]
  assert.equal! return_value.object_id, set.object_id
  assert.equal! set.reject!.class, Enumerator
  assert.nil!(set.reject! { |element| element > 1 })
  assert.equal! set, Set[1]
end

def test_set_classify(_args, assert)
  set = Set[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

  assert.equal! set.classify(&:even?), {
    true => Set[2, 4, 6, 8, 10],
    false => Set[1, 3, 5, 7, 9]
  }
end

def test_set_collect!(_args, assert)
  set = Set[1, 2, 3]
  return_value = set.collect! { |item| item * 2 }

  assert.equal! set, Set[2, 4, 6]
  assert.equal! set.object_id, return_value.object_id

  set.map! { |item| item * 2 }

  assert.equal! set, Set[4, 8, 12]
end

def test_set_divide_arity1(_args, assert)
  set = Set[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

  assert.equal! set.divide(&:even?), Set[
    Set[2, 4, 6, 8, 10],
    Set[1, 3, 5, 7, 9]
  ]
end

def test_set_divide_arity2(_args, assert)
  set = Set[1, -1, 2, -2]

  assert.equal! set.divide { |a, b| a.sign == b.sign }, Set[
    Set[1, 2],
    Set[-1, -2]
  ]
end

def test_set_flatten(_args, assert)
  set = Set[1, 2, 3, Set[4, 5, Set[6, 7]]]

  assert.equal! set.flatten, Set[1, 2, 3, 4, 5, 6, 7]
  assert.not_equal! set.flatten.object_id, set.object_id
end

def test_set_flatten!(_args, assert)
  set = Set[1, 2, 3, Set[4, 5, Set[6, 7]]]
  return_value = set.flatten!

  assert.equal! set, Set[1, 2, 3, 4, 5, 6, 7]
  assert.equal! set.object_id, return_value.object_id
  assert.nil! set.flatten!
end

def test_set_inspect(_args, assert)
  set = Set[1, 2]

  assert.equal! set.inspect, '#<Set: {1, 2}>'
  assert.equal! set.to_s, '#<Set: {1, 2}>'
end

def test_set_join(_args, assert)
  set = Set[1, 2, 3]

  assert.equal! set.join, '123'
  assert.equal! set.join('-'), '1-2-3'
end

def test_set_to_a(_args, assert)
  set = Set[1, 2, 3]

  assert.equal! set.to_a.sort, [1, 2, 3]
end

def test_set_each(_args, assert)
  set = Set[1, 2, 3]
  result = []

  set.each { |item| result << item }
  assert.equal! result.sort, [1, 2, 3]
  assert.equal! set.each.class, Enumerator
end
