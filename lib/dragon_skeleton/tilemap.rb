module DragonSkeleton
  class Tilemap
    def initialize(x:, y:, cell_w:, cell_h:, grid_w:, grid_h:)
    end

    def [](x, y)
      {}
    end

    def render(outputs)
      outputs.primitives << RenderedPrimitive.new
    end

    class RenderedPrimitive
      def draw_override(ffi_draw)
        [[0, 0, 1], [100, 0, 2], [0, 100, 3], [100, 100, 4], [0, 200, 5], [100, 200, 6]].each do |x, y, sprite_no|
          ffi_draw.draw_sprite_4 x, y, 100, 100,
                                 "sprites/#{sprite_no}.png",
                                 nil, # angle
                                 nil, nil, nil, nil, # a, r, g, b
                                 nil, nil, nil, nil, # tile_x, tile_y, tile_w, tile_h
                                 nil, nil, # flip_horizontally, flip_vertically
                                 nil, nil, # angle_anchor_x, angle_anchor_y
                                 nil, nil, nil, nil, # source_x, source_y, source_w, source_h
                                 nil # blendmode_enum
        end
      end
    end
  end
end
