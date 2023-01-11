DragonSkeleton.add_to_top_level_namespace

def test_file_formats_aseprite_json_read_as_animations(_args, assert)
  animations = FileFormats::AsepriteJson.read_as_animations 'tests/resources/character.json'
  expected_animations = {
    idle_right: Animations.build(
      frames: [
        {
          path: 'tests/resources/character.png',
          w: 48, h: 48,
          tile_x: 0, tile_y: 0, tile_w: 48, tile_h: 48,
          flip_horizontally: false,
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
      frames: [
        {
          path: 'tests/resources/character.png',
          w: 48, h: 48,
          tile_x: 48, tile_y: 0, tile_w: 48, tile_h: 48,
          flip_horizontally: false,
          duration: 3,
          metadata: {
            slices: {
              collider: { x: 6, y: 0, w: 22, h: 20 }
            }
          }
        },
        {
          path: 'tests/resources/character.png',
          w: 48, h: 48,
          tile_x: 96, tile_y: 0, tile_w: 48, tile_h: 48,
          flip_horizontally: false,
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

def test_file_formats_aseprite_json_flip_animation_horizontally(_args, assert)
  animation = Animations.build(
    frames: [
      {
        path: 'tests/resources/character.png',
        w: 48, h: 48,
        tile_x: 0, tile_y: 0, tile_w: 48, tile_h: 48,
        flip_horizontally: false,
        duration: 6,
        metadata: { slices: {} }
      }
    ]
  )
  flipped_animation = FileFormats::AsepriteJson.flip_animation_horizontally animation
  flipped_twice_animation = FileFormats::AsepriteJson.flip_animation_horizontally flipped_animation

  sprite1 = {}
  sprite2 = {}
  sprite3 = {}
  Animations.start! sprite1, animation: animation
  Animations.start! sprite2, animation: flipped_animation
  Animations.start! sprite3, animation: flipped_twice_animation

  assert.equal! sprite2.flip_horizontally, !sprite1.flip_horizontally, "Flipping didn't work"
  assert.equal! sprite3.flip_horizontally, !sprite2.flip_horizontally, "Flipping twice didn't work"
end

def test_file_formats_aseprite_json_flip_animation_horizontally_slices(_args, assert)
  animation = Animations.build(
    frames: [
      {
        path: 'tests/resources/character.png',
        w: 48, h: 48,
        tile_x: 0, tile_y: 0, tile_w: 48, tile_h: 48,
        flip_horizontally: false,
        duration: 6,
        metadata: {
          slices: {
            collider: { x: 5, y: 0, w: 20, h: 20 }
          }
        }
      }
    ]
  )
  flipped_animation = FileFormats::AsepriteJson.flip_animation_horizontally animation
  flipped_twice_animation = FileFormats::AsepriteJson.flip_animation_horizontally flipped_animation
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

def test_file_formats_aseprite_json_pingpong(_args, assert)
  animations = FileFormats::AsepriteJson.read_as_animations 'tests/resources/character_pingpong.json'
  expected_animations = {
    anim: Animations.build(
      frames: [
        {
          path: 'tests/resources/character.png',
          w: 48, h: 48,
          tile_x: 0, tile_y: 0, tile_w: 48, tile_h: 48,
          flip_horizontally: false,
          duration: 3,
          metadata: {
            slices: {}
          }
        },
        {
          path: 'tests/resources/character.png',
          w: 48, h: 48,
          tile_x: 48, tile_y: 0, tile_w: 48, tile_h: 48,
          flip_horizontally: false,
          duration: 3,
          metadata: {
            slices: {}
          }
        },
        {
          path: 'tests/resources/character.png',
          w: 48, h: 48,
          tile_x: 96, tile_y: 0, tile_w: 48, tile_h: 48,
          flip_horizontally: false,
          duration: 3,
          metadata: {
            slices: {}
          }
        },
        {
          path: 'tests/resources/character.png',
          w: 48, h: 48,
          tile_x: 48, tile_y: 0, tile_w: 48, tile_h: 48,
          flip_horizontally: false,
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
