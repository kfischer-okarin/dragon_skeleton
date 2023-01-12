require 'lib/dragon_skeleton.rb'
require 'lib/dragon_skeleton/animations.rb'
require 'lib/dragon_skeleton/animated_sprite.rb'
require 'lib/dragon_skeleton/file_formats/aseprite_json.rb'


def tick(args)
  args.state.functions_to_plot ||= []
  args.outputs.primitives << {
    x: 640, y: 360, text: 'Press p to generate easing function images',
    alignment_enum: 1, vertical_alignment_enum: 1
  }.label!

  if args.inputs.keyboard.key_down.p
    $gtk.system 'mkdir -p doc/images'
    args.state.functions_to_plot = DragonSkeleton::Animations::EASING_FUNCTIONS.keys
  end

  if args.state.functions_to_plot.any?
    function_name = args.state.functions_to_plot.shift
    args.outputs.primitives << { x: 0, y: 0, w: 100, h: 50, r: 100, g: 100, b: 100 }.solid!
    100.times do |x|
      y = DragonSkeleton::Animations::EASING_FUNCTIONS[function_name].call(x / 100.0) * 50
      args.outputs.primitives << { x: x, y: y, w: 1, h: 1, r: 0, g: 255, b: 0 }.solid!
    end
    args.outputs.screenshots << {
      x: 0, y: 0, w: 100, h: 50, path: "doc/images/easing_#{function_name}.png"
    }
  end
end

