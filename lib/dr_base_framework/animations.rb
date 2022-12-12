module Animations
  class << self
    def build(frames:, **base)
      {
        base: base,
        frames: frames.map { |frame|
          {
            duration: frame[:duration],
            metadata: frame[:metadata],
            values: frame.except(:duration, :metadata)
          }
        }
      }
    end

    def start!(primitive, animation:, repeat: true)
      {
        animation: animation,
        frame_index: 0,
        ticks: 0,
        repeat: repeat,
        finished: false
      }.tap { |animation_state|
        primitive.merge! animation[:base]
        apply! primitive, animation_state: animation_state
      }
    end

    def apply!(primitive, animation_state:)
      frame = current_frame(animation_state)
      primitive.merge! frame[:values]
    end

    def next_tick(animation_state)
      return if finished? animation_state

      frames = animation_state[:animation][:frames]

      animation_state[:ticks] += 1
      if animation_state[:ticks] >= frames[animation_state[:frame_index]][:duration]
        animation_state[:ticks] = 0

        if animation_state[:frame_index] < frames.length - 1
          animation_state[:frame_index] += 1
          return
        end

        if animation_state[:repeat]
          animation_state[:frame_index] = 0
        else
          animation_state[:finished] = true
        end
      end
    end

    def current_frame_metadata(animation_state)
      current_frame(animation_state)[:metadata]
    end

    def finished?(animation_state)
      animation_state[:finished]
    end

    private

    def current_frame(animation_state)
      animation_state[:animation][:frames][animation_state[:frame_index]]
    end
  end
end
