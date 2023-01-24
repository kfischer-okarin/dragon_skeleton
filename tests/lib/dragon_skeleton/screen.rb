DragonSkeleton.add_to_top_level_namespace

def test_screen_build_render_target(args, assert)
  [
    { resolution_args: [320], expected_width: 320, expected_height: 180 },
    { resolution_args: [64, 64], expected_width: 64, expected_height: 64 }
  ].each do |test_case|
    screen = Screen.with_resolution(*test_case[:resolution_args])

    render_target = Screen.build_render_target(args, screen)

    assert.equal! render_target.width,
                  test_case[:expected_width],
                  "Expected width to be #{test_case[:expected_width]}"
    assert.equal! render_target.height,
                  test_case[:expected_height],
                  "Expected height to be #{test_case[:expected_height]}"
  end
end
