module AnimatedSprite
  class << self
    def build(animations:, **base)
      base.to_sprite(
        animations: animations,
        animation: nil
      )
    end

    def perform_tick(animated_sprite, animation:)
      if animation == animated_sprite[:animation]
        Animations.perform_tick animated_sprite[:animation_state]
      else
        animated_sprite[:animation_state] = Animations.start!(
          animated_sprite,
          animation: animated_sprite[:animations][animation]
        )
        animated_sprite[:animation] = animation
      end
    end
  end
end
