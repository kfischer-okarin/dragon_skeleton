module DragonSkeleton
  # Provides a simple functional style animation system.
  #
  # In the simplest case, a frame is a hash of values to be set on the target and a
  # duration:
  #
  #   animation = Animations.build(
  #     frames: [
  #       { tile_x: 0, tile_y: 0, duration: 5 },
  #       { tile_x: 32, tile_y: 0, duration: 5 }
  #     ]
  #   )
  #
  # It can then be started via ::start! on a target (e.g. a sprite):
  #
  #   sprite = { x: 100, y: 100, w: 32, h: 32, tile_w: 32, tile_h: 32, path: 'resources/character.png' }
  #   animation_state = Animations.start! sprite, animation: animation
  #
  # and every tick you need to call ::perform_tick to advance the animation:
  #
  #   Animations.perform_tick animation_state
  #
  # By default the animation will stay on a frame until the duration is reached,
  # then immediately move to the next frame but you can also specify an easing
  # function to gradually interpolate between frames:
  #
  #   animation = Animations.build(
  #     frames: [
  #       { x: 0, y: 0, duration: 5, easing: :linear },
  #       { x: 100, tile_y: 100, duration: 5, easing: :linear }
  #     ]
  #   )
  module Animations
    class << self
      # Creates and starts a one-time animation that will interpolate between
      # the current values of the target and the values in the +to+ hash.
      #
      # Returns an animation state that can be passed to ::perform_tick.
      def lerp(target, to:, duration:)
        first_frame_values = {}.tap { |frame|
          to.each_key do |key|
            frame[key] = target[key]
          end
        }
        animation = build(
          frames: [
            first_frame_values.merge!(duration: duration, easing: :linear),
            to.dup
          ]
        )
        start! target, animation: animation, repeat: false
      end

      # Builds an animation from a list of frames.
      #
      # Each frame is a hash of values that will be set on
      # the target when the frame becomes active except for
      # the following reserved keys:
      #
      # [:duration] The number of ticks the frame will be active for.
      #
      #             This value is required except for the last frame
      #             of a non-repeating animation.
      #
      # [:metadata] A hash of metadata that is available via
      #             ::current_frame_metadata when the frame is active.
      #
      # [:easing] The easing function to use when interpolating between
      #           the current and next frame.
      #
      #           Check out the EASING_FUNCTIONS constant for a list of
      #           available easing functions.
      def build(frames:)
        {
          frames: frames.map { |frame|
            {
              duration: frame[:duration],
              metadata: frame[:metadata],
              easing: frame[:easing] || :none,
              values: frame.except(:duration, :metadata, :easing)
            }
          }
        }
      end

      # Starts an animation on a target and returns an animation state which can be
      # used to advance the animation via ::perform_tick.
      #
      # By default the animation will repeat indefinitely but this can be disabled
      # by setting <code>repeat: false</code>.
      def start!(target, animation:, repeat: true)
        {
          animation: animation,
          target: target,
          frame_index: 0,
          ticks: 0,
          repeat: repeat,
          finished: false
        }.tap { |animation_state|
          update_target animation_state
        }
      end

      # Advances the animation by one tick.
      def perform_tick(animation_state)
        next_tick animation_state
        update_target animation_state
      end

      # Returns the metadata associated with the active frame of the animation.
      def current_frame_metadata(animation_state)
        current_frame(animation_state)[:metadata]
      end

      # Returns +true+ if the animation has finished.
      def finished?(animation_state)
        animation_state[:finished]
      end

      private

      def next_tick(animation_state)
        return if finished? animation_state

        frames = animation_state[:animation][:frames]

        animation_state[:ticks] += 1
        return unless animation_state[:ticks] >= frames[animation_state[:frame_index]][:duration]

        animation_state[:ticks] = 0
        animation_state[:frame_index] = (animation_state[:frame_index] + 1) % frames.length
        return unless animation_state[:frame_index] == frames.length - 1 && !animation_state[:repeat]

        animation_state[:finished] = true
      end

      def update_target(animation_state)
        animation_state[:target].merge! current_frame_values(animation_state)
      end

      def current_frame_values(animation_state)
        frame = current_frame(animation_state)
        return frame[:values] if frame[:easing] == :none

        factor = EASING_FUNCTIONS[frame[:easing]].call(animation_state[:ticks] / frame[:duration])
        next_frame_values = next_frame(animation_state)[:values]
        {}.tap { |values|
          frame[:values].each do |key, value|
            values[key] = ((next_frame_values[key] - value) * factor + value).round
          end
        }
      end

      def current_frame(animation_state)
        animation_state[:animation][:frames][animation_state[:frame_index]]
      end

      def next_frame(animation_state)
        frames = animation_state[:animation][:frames]
        frames[(animation_state[:frame_index] + 1) % frames.length]
      end
    end

    # Easing functions for interpolating between frames.
    #
    # Following easing functions are provided but you can also add your own to this hash:
    #
    # [:linear] Linear interpolation between the current values and the values of the next frame.
    EASING_FUNCTIONS = {
      linear: ->(t) { t }
    }
  end
end
