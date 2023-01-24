DragonSkeleton.add_to_top_level_namespace

def test_screen_build_render_target(args, assert)
  screen = Screen.with_resolution(320, 180)

  render_target = Screen.build_render_target(args, screen)

  assert.equal! render_target.width, 320, 'Expected width to be 320'
  assert.equal! render_target.height, 180, 'Expected height to be 180'
end

def test_screen_sprite(_args, assert)
  [
    {
      screen: Screen.with_resolution(320, 180),
      expected_sprite: { x: 0, y: 0, w: 1280, h: 720, path: :screen }.sprite!
    },
    {
      screen: Screen.with_resolution(64, 64),
      expected_sprite: { x: 288, y: 8, w: 704, h: 704, path: :screen }.sprite!
    }
  ].each do |test_case|
    screen = test_case[:screen]

    sprite = Screen.sprite(screen)

    assert.equal! sprite, test_case[:expected_sprite]
  end
end
