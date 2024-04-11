module DragonSkeleton
  # A Tilemap manages a grid of tiles and renders them to the screen.
  #
  # Example:
  #
  #   args.state.tilemap ||= Tilemap.new(x: 0, y: 0, cell_w: 16, cell_h: 16, grid_w: 40, grid_h: 25)
  #   args.state.tilemap[0, 0].path = 'sprites/tiles/stone_floor.png'
  #   args.state.tilemap[1, 0].path = 'sprites/tiles/stone_wall.png'
  #   # ...
  #
  #   args.state.tilemap.render(args.outputs)
  class Tilemap
    # The x coordinate of the bottom left corner of the tilemap
    attr_accessor :x
    # The y coordinate of the bottom left corner of the tilemap
    attr_accessor :y
    # The width of each cell in the tilemap
    attr_reader :cell_w
    # The height of each cell in the tilemap
    attr_reader :cell_h
    # The width of the tilemap in cells
    attr_reader :grid_w
    # The height of the tilemap in cells
    attr_reader :grid_h

    # Creates a new tilemap.
    #
    # You can optionally pass a tileset to use for the tilemap.
    #
    # A tileset is an object that responds to the following methods:
    #
    # [+default_tile+] Returns a Hash with default values for each cell
    #
    # [+[]+] Receives a tile key as argument and returns a Hash with values for the
    #        given tile
    def initialize(x:, y:, cell_w:, cell_h:, grid_w:, grid_h:, tileset: nil)
      @x = x
      @y = y
      @cell_w = cell_w
      @cell_h = cell_h
      @grid_h = grid_h
      @grid_w = grid_w
      @tileset = tileset
      @cells = grid_h.times.flat_map { |grid_y|
        grid_w.times.map { |grid_x|
          Cell.new(grid_x * cell_w, grid_y * cell_h, tileset: tileset)
        }
      }
      @primitive = RenderedPrimitive.new(@cells, self)
    end

    # Returns the width of the tilemap in pixels.
    def w
      @grid_w * @cell_w
    end

    # Returns the height of the tilemap in pixels.
    def h
      @grid_h * @cell_h
    end

    # Returns the Cell at the given grid coordinates.
    def [](x, y)
      @cells[y * @grid_w + x]
    end

    # Renders the tilemap to the given outputs / render target.
    def render(outputs)
      outputs.primitives << @primitive
    end

    # Converts a position to grid coordinates.
    def to_grid_coordinates(position)
      {
        x: (position.x - @x).idiv(@cell_w),
        y: (position.y - @y).idiv(@cell_h)
      }
    end

    # Returns the rectangle of the cell at the given grid coordinates.
    def cell_rect(grid_coordinates)
      {
        x: @x + (grid_coordinates.x * @cell_w),
        y: @y + (grid_coordinates.y * @cell_h),
        w: @cell_w,
        h: @cell_h
      }
    end

    class RenderedPrimitive # :nodoc: Internal class responsible for rendering the tilemap.
      def initialize(cells, tilemap)
        @cells = cells
        @tilemap = tilemap
      end

      def primitive_marker
        :sprite
      end

      def draw_override(ffi_draw)
        origin_x = @tilemap.x
        origin_y = @tilemap.y
        w = @tilemap.cell_w
        h = @tilemap.cell_h
        cell_count = @cells.size
        cells = @cells
        index = 0

        while index < cell_count
          x, y, path, r, g, b, a, tile_x, tile_y, tile_w, tile_h, tile = cells[index]
          if path
            ffi_draw.draw_sprite_4 origin_x + x, origin_y + y, w, h,
                                   path,
                                   nil, # angle
                                   a, r, g, b,
                                   tile_x, tile_y, tile_w, tile_h,
                                   nil, nil, # flip_horizontally, flip_vertically
                                   nil, nil, # angle_anchor_x, angle_anchor_y
                                   nil, nil, nil, nil, # source_x, source_y, source_w, source_h
                                   nil # blendmode_enum
          end

          index += 1
        end
      end
    end
  end
end
