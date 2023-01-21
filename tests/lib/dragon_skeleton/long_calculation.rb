DragonSkeleton.add_to_top_level_namespace

def test_long_calculation_basic_behaviour(_args, assert)
  progress = []
  calculation = LongCalculation.define do
    progress << 1
    LongCalculation.finish_step
    progress << 2
    LongCalculation.finish_step
    :finished
  end

  calculation.resume

  assert.equal! progress, [1]
  assert.nil! calculation.result
  assert.false! calculation.finished?

  calculation.resume

  assert.equal! progress, [1, 2]
  assert.nil! calculation.result
  assert.false! calculation.finished?

  calculation.resume

  assert.equal! progress, [1, 2]
  assert.equal! calculation.result, :finished
  assert.true! calculation.finished?

  calculation.resume # should not raise any error
end

def test_long_calculation_inside_calculation(_args, assert)
  results = {}
  calculation = LongCalculation.define do
    results[:inside] = LongCalculation.inside_calculation?
    LongCalculation.finish_step
    :finished
  end

  results[:outside] = LongCalculation.inside_calculation?
  calculation.resume

  assert.equal! results, { outside: false, inside: true }
end

def test_long_calculation_do_nothing_when_finish_step_outside_calculation(_args, assert)
  LongCalculation.finish_step # should not raise any error
  assert.ok!
end

def test_long_calculation_finish(_args, assert)
  progress = []
  calculation = LongCalculation.define do
    10.times do |i|
      progress << i
      LongCalculation.finish_step
    end
    :finished
  end

  calculation.finish

  assert.equal! progress, [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
  assert.equal! calculation.result, :finished
end

def test_long_calculation_run_for_ms(_args, assert)
  calculation = LongCalculation.define do
    loop do
      LongCalculation.finish_step
    end
  end

  start_time = Time.now.to_f
  calculation.run_for_ms(5)
  end_time = Time.now.to_f

  run_time = (end_time - start_time) * 1000
  assert.true! run_time.between?(5, 10), "Expected fiber to run for rougly 5ms but it ran for #{run_time}ms"
  assert.false! calculation.finished?
end
