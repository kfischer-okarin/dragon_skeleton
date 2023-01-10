DragonSkeleton.add_to_top_level_namespace

def test_animations_asesprite_json_read(_args, assert)
  animations = Animations::AsespriteJson.read 'tests/resources/character.json'
  expected_animations = {
    idle_right: Animations.build(
      w: 48, h: 48, tile_w: 48, tile_h: 48, path: 'tests/resources/character.png',
      flip_horizontally: false,
      frames: [
        {
          tile_x: 0, tile_y: 0,
          duration: 6,
          metadata: {
            slices: {
              collider: { x: 5, y: 0, w: 20, h: 20 }
            }
          }
        }
      ]
    ),
    walk_right: Animations.build(
      w: 48, h: 48, tile_w: 48, tile_h: 48, path: 'tests/resources/character.png',
      flip_horizontally: false,
      frames: [
        {
          tile_x: 48, tile_y: 0,
          duration: 3,
          metadata: {
            slices: {
              collider: { x: 6, y: 0, w: 22, h: 20 }
            }
          }
        },
        {
          tile_x: 96, tile_y: 0,
          duration: 9,
          metadata: {
            slices: {
              collider: { x: 6, y: 0, w: 22, h: 20 }
            }
          }
        }
      ]
    )
  }

  assert.equal! animations, expected_animations
end

def test_animations_asesprite_json_flipped_horizontally(_args, assert)
  animation = Animations.build(
    w: 48, h: 48, tile_w: 48, tile_h: 48, path: 'tests/resources/character.png',
    flip_horizontally: false,
    frames: [
      {
        tile_x: 0, tile_y: 0,
        duration: 6,
        metadata: { slices: {} }
      }
    ]
  )
  flipped_animation = Animations::AsespriteJson.flipped_horizontally animation
  flipped_twice_animation = Animations::AsespriteJson.flipped_horizontally flipped_animation

  sprite1 = {}
  sprite2 = {}
  sprite3 = {}
  Animations.start! sprite1, animation: animation
  Animations.start! sprite2, animation: flipped_animation
  Animations.start! sprite3, animation: flipped_twice_animation

  assert.equal! sprite2.flip_horizontally, !sprite1.flip_horizontally, "Flipping didn't work"
  assert.equal! sprite3.flip_horizontally, !sprite2.flip_horizontally, "Flipping twice didn't work"
end

def test_animations_asesprite_json_flipped_horizontally_slices(_args, assert)
  animation = Animations.build(
    w: 48, h: 48, tile_w: 48, tile_h: 48, path: 'tests/resources/character.png',
    flip_horizontally: false,
    frames: [
      {
        tile_x: 0, tile_y: 0,
        duration: 6,
        metadata: {
          slices: {
            collider: { x: 5, y: 0, w: 20, h: 20 }
          }
        }
      }
    ]
  )
  flipped_animation = Animations::AsespriteJson.flipped_horizontally animation
  flipped_twice_animation = Animations::AsespriteJson.flipped_horizontally flipped_animation
  flipped_state = Animations.start!({}, animation: flipped_animation)
  flipped_twice_state = Animations.start!({}, animation: flipped_twice_animation)

  flipped_metadata = Animations.current_frame_metadata flipped_state
  flipped_twice_metadata = Animations.current_frame_metadata flipped_twice_state

  assert.equal! flipped_metadata,
                {
                  slices: {
                    collider: { x: 23, y: 0, w: 20, h: 20 }
                  }
                },
                "Slices weren't flipped"
  assert.equal! flipped_twice_metadata,
                {
                  slices: {
                    collider: { x: 5, y: 0, w: 20, h: 20 }
                  }
                },
                "Slices weren't flipped back"
end

def test_animations_asesprite_json_pingpong(_args, assert)
  animations = Animations::AsespriteJson.read 'tests/resources/character_pingpong.json'
  expected_animations = {
    anim: Animations.build(
      w: 48, h: 48, tile_w: 48, tile_h: 48, path: 'tests/resources/character.png',
      flip_horizontally: false,
      frames: [
        {
          tile_x: 0, tile_y: 0,
          duration: 3,
          metadata: {
            slices: {}
          }
        },
        {
          tile_x: 48, tile_y: 0,
          duration: 3,
          metadata: {
            slices: {}
          }
        },
        {
          tile_x: 96, tile_y: 0,
          duration: 3,
          metadata: {
            slices: {}
          }
        },
        {
          tile_x: 48, tile_y: 0,
          duration: 3,
          metadata: {
            slices: {}
          }
        }
      ]
    ),
  }

  assert.equal! animations, expected_animations
end
