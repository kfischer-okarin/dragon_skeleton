DragonSkeleton.add_to_top_level_namespace

def test_tilemap_render_renders_tiles_with_path(args, assert)
  tilemap = Tilemap.new(x: 50, y: 50, cell_w: 100, cell_h: 100, grid_w: 2, grid_h: 3)
  tilemap[0, 0].path = 'tile.png'
  tilemap[0, 0].g = 255
  tilemap[1, 2].assign(r: 255, path: 'tile2.png')
  tilemap[0, 1].g = 255

  tilemap.render(args.outputs)

  assert.equal! args.outputs.primitives.length, 1

  primitive = args.outputs.primitives.first
  assert.equal! primitive.primitive_marker, :sprite

  spy = Spy.new
  primitive.draw_override spy
  # rubocop:disable all
  assert.equal! spy.calls, [
    [
      :draw_sprite_4,
      #   x,   y,   w,   h,       path, angle,   a,   r,   g,   b, tile_x, tile_y, tile_w, tile_h, flip_horizontally, flip_vertically, angle_anchor_x, angle_anchor_y, source_x, source_y, source_w, source_h, blendmode_enum
      [  50,  50, 100, 100, 'tile.png',   nil, nil, nil, 255, nil,    nil,    nil,    nil,    nil,               nil,             nil,            nil,            nil,      nil,      nil,      nil,      nil,            nil]
    ],
    [
      :draw_sprite_4,
      #   x,   y,   w,   h,        path, angle,   a,   r,   g,   b, tile_x, tile_y, tile_w, tile_h, flip_horizontally, flip_vertically, angle_anchor_x, angle_anchor_y, source_x, source_y, source_w, source_h, blendmode_enum
      [ 150, 250, 100, 100, 'tile2.png',   nil, nil, 255, nil, nil,    nil,    nil,    nil,    nil,               nil,             nil,            nil,            nil,      nil,      nil,      nil,      nil,            nil]
    ]
  ]
  # rubocop:enable all
end

def test_tilemap_to_grid_coordinates(_args, assert)
  tilemap = Tilemap.new(x: 50, y: 50, cell_w: 100, cell_h: 100, grid_w: 2, grid_h: 3)

  assert.equal! tilemap.to_grid_coordinates({ x: 55, y: 55 }), { x: 0, y: 0 }
end

def test_tilemap_cell_rect(_args, assert)
  tilemap = Tilemap.new(x: 50, y: 50, cell_w: 100, cell_h: 100, grid_w: 2, grid_h: 3)

  assert.equal! tilemap.cell_rect({ x: 1, y: 2 }), { x: 150, y: 250, w: 100, h: 100 }
end

def test_tilemap_w_h(_args, assert)
  tilemap = Tilemap.new(x: 50, y: 50, cell_w: 100, cell_h: 100, grid_w: 2, grid_h: 3)

  assert.equal! tilemap.w, 200
  assert.equal! tilemap.h, 300
end

def test_tilemap_tileset_assigns_default_tile(_args, assert)
  tileset = TestTileset.new(
    default_tile: { tile_w: 50, tile_h: 50 },
  )

  tilemap = Tilemap.new(x: 50, y: 50, cell_w: 100, cell_h: 100, grid_w: 2, grid_h: 3, tileset: tileset)

  assert.equal! tilemap[0, 0].tile_w, 50
  assert.equal! tilemap[0, 0].tile_h, 50
end

def test_tilemap_tileset_assigns_tile_values(_args, assert)
  tileset = TestTileset.new(
    tiles: {
      grass: { tile_x: 100, tile_y: 100 }
    }
  )
  tilemap = Tilemap.new(x: 50, y: 50, cell_w: 100, cell_h: 100, grid_w: 2, grid_h: 3, tileset: tileset)

  tilemap[0, 0].tile = :grass

  assert.equal! tilemap[0, 0].tile_x, 100
  assert.equal! tilemap[0, 0].tile_y, 100
end

def test_tilemap_cell_does_not_assign_tile_values_if_same_tile(_args, assert)
  tileset = TestTileset.new(
    tiles: {
      grass: { tile_x: 100, tile_y: 100 }
    }
  )
  tilemap = Tilemap.new(x: 50, y: 50, cell_w: 100, cell_h: 100, grid_w: 2, grid_h: 3, tileset: tileset)
  tilemap[0, 0].tile = :grass
  tilemap[0, 0].tile_x = 999

  tilemap[0, 0].tile = :grass

  assert.equal! tilemap[0, 0].tile_x, 999
end

def test_tilemap_cell_resets_path_when_assigning_nil_as_tile(_args, assert)
  tileset = TestTileset.new(
    tiles: {
      grass: { path: 'grass.png' }
    }
  )
  tilemap = Tilemap.new(x: 50, y: 50, cell_w: 100, cell_h: 100, grid_w: 2, grid_h: 3, tileset: tileset)
  tilemap[0, 0].tile = :grass
  tilemap[0, 0].tile = nil

  assert.nil! tilemap[0, 0].path
end

def test_tilemap_cell_ignores_unknown_tile_values_when_assigning(_args, assert)
  tilemap = Tilemap.new(x: 50, y: 50, cell_w: 100, cell_h: 100, grid_w: 2, grid_h: 3)
  tilemap[0, 0].assign(tile_x: 100, score: 100)

  assert.ok! # no error
end

class Spy
  attr_reader :calls

  def initialize
    @calls = []
  end

  def method_missing(method_name, *args)
    @calls << [method_name, args]
  end
end

class TestTileset
  attr_reader :default_tile

  def initialize(default_tile: nil, tiles: nil)
    @default_tile = default_tile || {}
    @tiles = tiles || {}
  end

  def [](tile)
    @tiles[tile]
  end
end
