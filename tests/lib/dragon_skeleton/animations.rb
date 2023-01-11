DragonSkeleton.add_to_top_level_namespace

def test_animations_integration_test(_args, assert)
  animation = Animations.build(
    frames: [
      { tile_x: 0, tile_y: 0, duration: 3 },
      { tile_x: 48, tile_y: 48, duration: 3 }
    ]
  )
  primitive = { x: 100, y: 100, w: 48, h: 48, tile_w: 48, tile_h: 48, path: 'resources/character.png' }
  first_frame = {
    x: 100, y: 100,
    w: 48, h: 48,
    tile_x: 0, tile_y: 0, tile_w: 48, tile_h: 48,
    path: 'resources/character.png'
  }
  second_frame = {
    x: 100, y: 100,
    w: 48, h: 48,
    tile_x: 48, tile_y: 48, tile_w: 48, tile_h: 48,
    path: 'resources/character.png'
  }

  animation_state = Animations.start! primitive, animation: animation
  assert.equal! primitive, first_frame

  2.times do
    Animations.perform_tick animation_state

    assert.equal! primitive, first_frame
  end

  3.times do
    Animations.perform_tick animation_state

    assert.equal! primitive, second_frame
  end

  Animations.perform_tick animation_state

  assert.equal! primitive, first_frame
end

def test_animations_integration_test_no_repeat(_args, assert)
  animation = Animations.build(
    frames: [
      { tile_x: 0, tile_y: 0, duration: 3 },
      { tile_x: 48, tile_y: 48 }
    ]
  )
  primitive = { x: 100, y: 100, w: 48, h: 48, tile_w: 48, tile_h: 48, path: 'resources/character.png',}
  first_frame = {
    x: 100, y: 100,
    w: 48, h: 48,
    tile_x: 0, tile_y: 0, tile_w: 48, tile_h: 48,
    path: 'resources/character.png'
  }
  second_frame = {
    x: 100, y: 100,
    w: 48, h: 48,
    tile_x: 48, tile_y: 48, tile_w: 48, tile_h: 48,
    path: 'resources/character.png'
  }

  animation_state = Animations.start! primitive, animation: animation, repeat: false
  assert.equal! primitive, first_frame

  2.times do
    Animations.perform_tick animation_state

    assert.equal! primitive, first_frame
  end

  3.times do
    Animations.perform_tick animation_state

    assert.equal! primitive, second_frame
  end

  Animations.perform_tick animation_state

  assert.equal! primitive, second_frame
end

def test_animations_integration_test_linear_easing(_args, assert)
  animation = Animations.build(
    frames: [
      { alpha: 0, duration: 3, easing: :linear },
      { alpha: 255 }
    ]
  )
  primitive = {}
  animation_state = Animations.start! primitive, animation: animation, repeat: false
  assert.equal! primitive, { alpha: 0 }

  Animations.perform_tick animation_state

  assert.equal! primitive, { alpha: 85 }

  Animations.perform_tick animation_state

  assert.equal! primitive, { alpha: 170 }

  Animations.perform_tick animation_state

  assert.equal! primitive, { alpha: 255 }
end

def test_animations_metadata(_args, assert)
  animation = Animations.build(
    frames: [
      { duration: 3, metadata: { color: :red } },
      { duration: 3, metadata: { color: :green } }
    ]
  )
  primitive = {}
  animation_state = Animations.start!(primitive, animation: animation)

  assert.equal! primitive, {}
  assert.equal! Animations.current_frame_metadata(animation_state), { color: :red }

  2.times do
    Animations.perform_tick animation_state

    assert.equal! primitive, {}
    assert.equal! Animations.current_frame_metadata(animation_state), { color: :red }
  end

  3.times do
    Animations.perform_tick animation_state

    assert.equal! primitive, {}
    assert.equal! Animations.current_frame_metadata(animation_state), { color: :green }
  end

  Animations.perform_tick animation_state

  assert.equal! primitive, {}
  assert.equal! Animations.current_frame_metadata(animation_state), { color: :red }
end

def test_animations_finished_repeating_animation(_args, assert)
  animation = AnimationsTests.an_animation(length: 3)

  animation_state = Animations.start!({}, animation: animation)

  assert.false! Animations.finished? animation_state

  3.times do
    Animations.perform_tick animation_state

    assert.false! Animations.finished? animation_state
  end
end

def test_animations_finished_one_time_animation(_args, assert)
  animation = AnimationsTests.an_animation(length: 3)

  animation_state = Animations.start!({}, animation: animation, repeat: false)

  assert.false! Animations.finished? animation_state

  2.times do
    Animations.perform_tick animation_state

    assert.false! Animations.finished? animation_state
  end

  Animations.perform_tick animation_state

  assert.true! Animations.finished? animation_state
end

def test_animations_lerp(_args, assert)
  primitive = { x: 100 }

  animation_state = Animations.lerp(primitive, to: { x: 200 }, duration: 3)

  Animations.perform_tick animation_state

  assert.equal! primitive, { x: 133 }
end

module AnimationsTests
  class << self
    def an_animation(length: 6)
      Animations.build(
        frames: [
          { tile_x: 0, tile_y: 0, duration: length }
        ]
      )
    end
  end
end
