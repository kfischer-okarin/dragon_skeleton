require 'lib/dragon_skeleton/animations.rb'

def plot_easing_function(name)
  easing_function = DragonSkeleton::Animations::EASING_FUNCTIONS[name]
  $outputs.primitives << { x: 500, y: 500, w: 100, h: 50, r: 100, g: 100, b: 100 }.solid!
  100.times do |x|
    y = easing_function.call(x / 100.0) * 50
    $outputs.primitives << { x: 500 + x, y: 500 + y, w: 1, h: 1, r: 0, g: 255, b: 0 }.solid!
  end
  $outputs.screenshots << { x: 500, y: 500, w: 100, h: 50, path: "doc/images/easing_#{name}.png" }
end

$gtk.reset
$gtk.scheduled_callbacks.clear

$gtk.schedule_callback 1 do
  scheduled_tick = 2
  DragonSkeleton::Animations::EASING_FUNCTIONS.each_key do |function_name|
    $gtk.schedule_callback scheduled_tick do
      plot_easing_function function_name
    end
    scheduled_tick += 2
  end

  $gtk.schedule_callback scheduled_tick do
    $gtk.exit
  end
end
