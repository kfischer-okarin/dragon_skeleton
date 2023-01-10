DragonSkeleton.add_to_top_level_namespace

def test_animated_sprite_integration_test(_args, assert)
  animation_a = Animations.build(
    w: 48, h: 48,
    frames: [
      { tile_x: 0, tile_y: 0, duration: 2 },
      { tile_x: 48, tile_y: 48, duration: 2 }
    ]
  )
  animation_b = Animations.build(
    w: 96, h: 96,
    frames: [
      { tile_x: 0, tile_y: 0, duration: 4 },
      { tile_x: 96, tile_y: 96, duration: 4 }
    ]
  )
  animations = {
    a: animation_a,
    b: animation_b
  }
  animated_sprite = AnimatedSprite.build w: 0, h: 0, animations: animations
  assert.equal! animated_sprite[:primitive_marker], :sprite

  2.times do
    AnimatedSprite.perform_tick animated_sprite, animation: :a
    assert.equal! animated_sprite.slice(:w, :h, :tile_x, :tile_y),
                  { w: 48, h: 48, tile_x: 0, tile_y: 0 }
  end

  AnimatedSprite.perform_tick animated_sprite, animation: :a
  assert.equal! animated_sprite.slice(:w, :h, :tile_x, :tile_y),
                { w: 48, h: 48, tile_x: 48, tile_y: 48 }

  AnimatedSprite.perform_tick animated_sprite, animation: :b
  assert.equal! animated_sprite.slice(:w, :h, :tile_x, :tile_y, :next_animation),
                { w: 96, h: 96, tile_x: 0, tile_y: 0 }
end

module AnimatedSpriteTests
  class << self
    def an_animation(length: 6)
      Animations.build(
        w: 48, h: 48, tile_w: 48, tile_h: 48, path: 'resources/character.png',
        frames: [
          { tile_x: 0, tile_y: 0, duration: length }
        ]
      )
    end
  end
end
