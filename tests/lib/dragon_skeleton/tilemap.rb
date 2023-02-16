DragonSkeleton.add_to_top_level_namespace

def test_tilemap_render(args, assert)
  tilemap = Tilemap.new(x: 0, y: 0, cell_w: 100, cell_h: 100, grid_w: 2, grid_h: 3)
  tilemap[0, 0].path = 'tile.png'
  tilemap[1, 0].r = 255
  tilemap[0, 1].g = 255
  tilemap[1, 1].b = 255
  tilemap[0, 2].a = 255

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
      [   0,   0, 100, 100, 'tile.png',   nil, nil, nil, nil, nil,    nil,    nil,    nil,    nil,               nil,             nil,            nil,            nil,      nil,      nil,      nil,      nil,            nil]
    ],
    [
      :draw_sprite_4,
      #   x,   y,   w,   h,       path, angle,   a,   r,   g,   b, tile_x, tile_y, tile_w, tile_h, flip_horizontally, flip_vertically, angle_anchor_x, angle_anchor_y, source_x, source_y, source_w, source_h, blendmode_enum
      [ 100,   0, 100, 100,        nil,   nil, nil, 255, nil, nil,    nil,    nil,    nil,    nil,               nil,             nil,            nil,            nil,      nil,      nil,      nil,      nil,            nil]
    ],
    [
      :draw_sprite_4,
      #   x,   y,   w,   h,       path, angle,   a,   r,   g,   b, tile_x, tile_y, tile_w, tile_h, flip_horizontally, flip_vertically, angle_anchor_x, angle_anchor_y, source_x, source_y, source_w, source_h, blendmode_enum
      [   0, 100, 100, 100,        nil,   nil, nil, nil, 255, nil,    nil,    nil,    nil,    nil,               nil,             nil,            nil,            nil,      nil,      nil,      nil,      nil,            nil]
    ],
    [
      :draw_sprite_4,
      #   x,   y,   w,   h,       path, angle,   a,   r,   g,   b, tile_x, tile_y, tile_w, tile_h, flip_horizontally, flip_vertically, angle_anchor_x, angle_anchor_y, source_x, source_y, source_w, source_h, blendmode_enum
      [ 100, 100, 100, 100,        nil,   nil, nil, nil, nil, 255,    nil,    nil,    nil,    nil,               nil,             nil,            nil,            nil,      nil,      nil,      nil,      nil,            nil]
    ],
    [
      :draw_sprite_4,
      #   x,   y,   w,   h,       path, angle,   a,   r,   g,   b, tile_x, tile_y, tile_w, tile_h, flip_horizontally, flip_vertically, angle_anchor_x, angle_anchor_y, source_x, source_y, source_w, source_h, blendmode_enum
      [   0, 200, 100, 100,        nil,   nil, 255, nil, nil, nil,    nil,    nil,    nil,    nil,               nil,             nil,            nil,            nil,      nil,      nil,      nil,      nil,            nil]
    ],
    [
      :draw_sprite_4,
      #   x,   y,   w,   h,            path, angle,   a,   r,   g,   b, tile_x, tile_y, tile_w, tile_h, flip_horizontally, flip_vertically, angle_anchor_x, angle_anchor_y, source_x, source_y, source_w, source_h, blendmode_enum
      [ 100, 200, 100, 100,             nil,   nil, nil, nil, nil, nil,    nil,    nil,    nil,    nil,               nil,             nil,            nil,            nil,      nil,      nil,      nil,      nil,            nil]
    ]
  ]
  # rubocop:enable all
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
