module DragonSkeleton
  class Tilemap
    def initialize(x:, y:, cell_w:, cell_h:, grid_w:, grid_h:)
      @grid_w = grid_w
      @tiles = grid_h.times.flat_map { |grid_y|
        grid_w.times.map { |grid_x|
          [
            x + grid_x * cell_w,
            y + grid_y * cell_h,
            nil, # path
            nil, nil, nil, nil # r, g, b, a
          ].tap { |tile| tile.extend(Tile) }
        }
      }
      @primitive = RenderedPrimitive.new(@tiles, cell_w, cell_h)
    end

    def [](x, y)
      @tiles[y * @grid_w + x]
    end

    def render(outputs)
      outputs.primitives << @primitive
    end

    module Tile
      def path
        self[2]
      end

      def path=(path)
        self[2] = path
      end

      def r
        self[3]
      end

      def r=(r)
        self[3] = r
      end

      def g
        self[4]
      end

      def g=(g)
        self[4] = g
      end

      def b
        self[5]
      end

      def b=(b)
        self[5] = b
      end

      def a
        self[6]
      end

      def a=(a)
        self[6] = a
      end
    end

    class RenderedPrimitive
      def initialize(tiles, cell_w, cell_h)
        @tiles = tiles
        @cell_w = cell_w
        @cell_h = cell_h
      end

      def primitive_marker
        :sprite
      end

      def draw_override(ffi_draw)
        w = @cell_w
        h = @cell_h

        @tiles.each do |tile|
          x, y, path, r, g, b, a = tile
          ffi_draw.draw_sprite_4 x, y, w, h,
                                 path,
                                 nil, # angle
                                 a, r, g, b, # a, r, g, b
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