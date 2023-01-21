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

  result = calculation.resume

  assert.equal! progress, [1]
  assert.nil! result

  result = calculation.resume

  assert.equal! progress, [1, 2]
  assert.nil! result

  result = calculation.resume

  assert.equal! progress, [1, 2]
  assert.equal! result, :finished
end

def test_long_calculation_do_nothing_when_finish_step_outside_calculation(_args, assert)
  LongCalculation.finish_step # should not raise any error
  assert.ok!
end
