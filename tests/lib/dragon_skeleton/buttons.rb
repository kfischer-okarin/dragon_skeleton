DragonSkeleton.add_to_top_level_namespace

def test_buttons_handle_mouse_input_hovered(args, assert)
  button = { x: 100, y: 100, w: 100, h: 100 }
  mouse = args.inputs.mouse
  mouse.x = 150
  mouse.y = 150

  Buttons.handle_mouse_input mouse, button

  assert.true! button[:hovered]

  mouse.x = 50
  mouse.y = 50

  Buttons.handle_mouse_input mouse, button

  assert.false! button[:hovered]
end

def test_buttons_handle_mouse_input_hovered_ticks(args, assert)
  button = { x: 100, y: 100, w: 100, h: 100 }
  mouse = args.inputs.mouse
  mouse.x = 150
  mouse.y = 150

  Buttons.handle_mouse_input mouse, button
  Buttons.handle_mouse_input mouse, button

  assert.equal! button[:hovered_ticks], 2

  mouse.x = 50
  mouse.y = 50

  Buttons.handle_mouse_input mouse, button

  assert.equal! button[:hovered_ticks], 0
end

def test_buttons_handle_mouse_input_clicked(args, assert)
  button = { x: 100, y: 100, w: 100, h: 100 }
  mouse = args.inputs.mouse
  mouse.x = 150
  mouse.y = 150

  Buttons.handle_mouse_input mouse, button

  assert.false! button[:clicked]

  mouse.click = {} # non-nil value

  Buttons.handle_mouse_input mouse, button

  assert.true! button[:clicked]

  mouse.x = 50
  mouse.y = 50

  Buttons.handle_mouse_input mouse, button

  assert.false! button[:clicked]
end

def test_buttons_handle_mouse_input_pressed(args, assert)
  button = { x: 100, y: 100, w: 100, h: 100 }
  mouse = args.inputs.mouse
  mouse.x = 150
  mouse.y = 150

  Buttons.handle_mouse_input mouse, button

  assert.false! button[:pressed]

  mouse.button_left = true

  Buttons.handle_mouse_input mouse, button

  assert.true! button[:pressed]

  mouse.x = 50
  mouse.y = 50

  Buttons.handle_mouse_input mouse, button

  assert.false! button[:pressed]
end

def test_buttons_handle_mouse_input_pressed_ticks(args, assert)
  button = { x: 100, y: 100, w: 100, h: 100 }
  mouse = args.inputs.mouse
  mouse.x = 150
  mouse.y = 150
  mouse.button_left = true

  Buttons.handle_mouse_input mouse, button
  Buttons.handle_mouse_input mouse, button

  assert.equal! button[:pressed_ticks], 2

  mouse.button_left = false

  Buttons.handle_mouse_input mouse, button

  assert.equal! button[:pressed_ticks], 0
end

def test_buttons_handle_mouse_input_released(args, assert)
  button = { x: 100, y: 100, w: 100, h: 100 }
  mouse = args.inputs.mouse
  mouse.x = 150
  mouse.y = 150

  Buttons.handle_mouse_input mouse, button

  assert.false! button[:released]

  mouse.button_left = true

  Buttons.handle_mouse_input mouse, button

  assert.false! button[:released]

  mouse.button_left = false

  Buttons.handle_mouse_input mouse, button

  assert.true! button[:released]

  Buttons.handle_mouse_input mouse, button

  assert.false! button[:released]
end

def test_buttons_handle_mouse_input_ticks_since_released(args, assert)
  button = { x: 100, y: 100, w: 100, h: 100 }
  mouse = args.inputs.mouse
  mouse.x = 150
  mouse.y = 150
  mouse.button_left = true

  Buttons.handle_mouse_input mouse, button

  assert.equal! button[:ticks_since_released], 1

  mouse.button_left = false

  Buttons.handle_mouse_input mouse, button

  assert.equal! button[:ticks_since_released], 0

  Buttons.handle_mouse_input mouse, button
  Buttons.handle_mouse_input mouse, button

  assert.equal! button[:ticks_since_released], 2
end
