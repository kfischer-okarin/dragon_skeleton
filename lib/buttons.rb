# Contains methods for handling common button input logic.
module Buttons
  class << self
    # Processes mouse input for the given button (a hash with x, y, w, and h keys)
    # and updates the button hash with the following keys:
    #
    # [:hovered] +true+ while the mouse is inside the button
    #
    # [:hovered_ticks] the number of ticks the mouse has been inside the button
    #
    # [:clicked] +true+ if the mouse was clicked inside the button
    #
    # [:pressed] +true+ while the mouse is inside the button and the left mouse
    #            button is pressed
    #
    # [:pressed_ticks] the number of ticks the mouse has been inside the button
    #                  and the left mouse button is pressed
    #
    # [:released] +true+ during the tick when left mouse button was released after
    #             being pressed inside the button
    #
    # [:ticks_since_released] the number of ticks since the mouse was released
    def handle_mouse_input(mouse, button)
      button[:hovered_ticks] ||= 0
      button[:pressed_ticks] ||= 0
      button[:ticks_since_released] ||= 0
      button[:hovered] = mouse.inside_rect? button
      button[:hovered_ticks] = button[:hovered] ? button[:hovered_ticks] + 1 : 0
      button[:clicked] = button[:hovered] && mouse.click
      button[:pressed] = button[:hovered] && mouse.button_left
      button[:released] = button[:pressed_ticks].positive? && !mouse.button_left
      button[:pressed_ticks] = button[:pressed] ? button[:pressed_ticks] + 1 : 0
      button[:ticks_since_released] = button[:released] ? 0 : button[:ticks_since_released] + 1
    end
  end
end
