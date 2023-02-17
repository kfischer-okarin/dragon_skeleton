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
    attr_accessor :x, :y
    attr_reader :grid_w, :grid_h, :cell_w, :cell_h

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
          [
            grid_x * cell_w,
            grid_y * cell_h,
            nil, # path
            nil, nil, nil, nil, # r, g, b, a
            nil, nil, nil, nil, # tile_x, tile_y, tile_w, tile_h
            nil # tile
          ].tap { |cell|
            cell.extend(Cell)
            if tileset
              cell.assign(tileset.default_tile)
              cell.define_singleton_method(:tile=) do |tile|
                assign(tileset[tile])
                self[Cell.property_index(:tile)] = tile
              end
            end
          }
        }
      }
      @primitive = RenderedPrimitive.new(@cells, self)
    end

    # Returns the cell at the given grid coordinates.
    def [](x, y)
      @cells[y * @grid_w + x]
    end

    # Renders the tilemap to the given outputs / render target.
    def render(outputs)
      outputs.primitives << @primitive
    end

    module Cell # :nodoc: For extending an array with accessors for cell properties.
      def self.array_accessors(*names)
        @property_indexes = {}
        names.each_with_index do |name, index|
          @property_indexes[name] = index
          define_method(name) { self[index] }
          define_method("#{name}=") { |value| self[index] = value }
        end
      end

      def self.property_index(name)
        @property_indexes[name]
      end

      array_accessors :x, :y, :path, :r, :g, :b, :a, :tile_x, :tile_y, :tile_w, :tile_h, :tile

      def assign(values)
        values.each do |name, value|
          self[Cell.property_index(name)] = value
        end
      end
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
          x, y, path, r, g, b, a, tile_x, tile_y, tile_w, tile_h = cells[index]
          ffi_draw.draw_sprite_4 origin_x + x, origin_y + y, w, h,
                                 path,
                                 nil, # angle
                                 a, r, g, b,
                                 tile_x, tile_y, tile_w, tile_h,
                                 nil, nil, # flip_horizontally, flip_vertically
                                 nil, nil, # angle_anchor_x, angle_anchor_y
                                 nil, nil, nil, nil, # source_x, source_y, source_w, source_h
                                 nil # blendmode_enum

          index += 1
        end
      end
    end
  end
end
