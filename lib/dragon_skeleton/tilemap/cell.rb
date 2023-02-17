module DragonSkeleton
  class Tilemap
    # A single cell in a tilemap.
    #
    # A cell is an Array with the following values which are also available as
    # attributes:
    #
    # - +x+ (read-only)
    # - +y+ (read-only)
    # - +path+
    # - +r+
    # - +g+
    # - +b+
    # - +a+
    # - +tile_x+
    # - +tile_y+
    # - +tile_w+
    # - +tile_h+
    # - +tile+: The key of the tile to use for this cell
    class Cell < Array
      def self.index_accessors(*names) # :nodoc: Internal method used to define accessors for the cell values.
        @property_indexes = {}
        names.each_with_index do |name, index|
          @property_indexes[name] = index
          define_method(name) { self[index] }
          define_method("#{name}=") { |value| self[index] = value }
        end
      end

      # Returns the index of the given property.
      def self.property_index(name)
        @property_indexes[name]
      end

      index_accessors :x, :y, :path, :r, :g, :b, :a, :tile_x, :tile_y, :tile_w, :tile_h, :tile

      undef_method :x=
      undef_method :y=

      def initialize(x, y, tileset: nil) # :nodoc: The user should not create cells directly.
        super(12)

        self[0] = x
        self[1] = y
        return unless tileset

        assign(tileset.default_tile)
        tile_index = Cell.property_index(:tile)
        define_singleton_method(:tile=) do |tile|
          assign(tileset[tile])
          self[tile_index] = tile
        end
      end

      # Assigns the given values to the cell.
      #
      # Example:
      #
      #   cell.assign(path: 'sprites/box.png', r: 255, g: 0, b: 0)
      def assign(values)
        values.each do |name, value|
          self[Cell.property_index(name)] = value
        end
      end
    end
  end
end
