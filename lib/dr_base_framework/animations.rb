module Animations
  class << self
    def animate(object, to:, duration:)
      first_frame_values = {}.tap { |frame|
        to.each_key do |key|
          frame[key] = object[key]
        end
      }
      animation = build(
        frames: [
          first_frame_values.merge!(duration: duration, easing: :linear),
          to.dup
        ]
      )
      start! object, animation: animation, repeat: false
    end

    def build(frames:, **base)
      {
        base: base,
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

    def start!(target, animation:, repeat: true)
      {
        animation: animation,
        target: target,
        frame_index: 0,
        ticks: 0,
        repeat: repeat,
        finished: false
      }.tap { |animation_state|
        target.merge! animation[:base]
        apply! target, animation_state: animation_state
      }
    end

    def perform_tick(animation_state)
      next_tick animation_state
      apply! animation_state[:target], animation_state: animation_state
    end

    def apply!(target, animation_state:)
      target.merge! current_frame_values(animation_state)
    end

    def current_frame_metadata(animation_state)
      current_frame(animation_state)[:metadata]
    end

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

    def current_frame_values(animation_state)
      frame = current_frame(animation_state)
      return frame[:values] if frame[:easing] == :none

      factor = Easing.send(frame[:easing], animation_state[:ticks] / frame[:duration])
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

  module Easing
    class << self
      def linear(t)
        t
      end
    end
  end
end
