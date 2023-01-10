module Animations
  module AsespriteJson
    class << self
      def read(path)
        sprite_sheet_data = deep_symbolize_keys! $gtk.parse_json_file(path)

        base = build_base(sprite_sheet_data, path)

        {}.tap { |result|
          frame_size = base.slice(:w, :h)
          frames = sprite_sheet_data.fetch :frames
          slices_data = sprite_sheet_data.fetch(:meta).fetch :slices

          sprite_sheet_data.fetch(:meta).fetch(:frameTags).each do |frame_tag_data|
            tag = frame_tag_data.fetch(:name).to_sym
            frame_range = frame_tag_data.fetch(:from)..frame_tag_data.fetch(:to)
            tag_frames = frame_range.map { |frame_index|
              frame_data = frames[frame_index]
              frame = frame_data.fetch(:frame)
              {
                tile_x: frame[:x],
                tile_y: frame[:y],
                duration: frame_data.fetch(:duration).idiv(50) * 3, # 50ms = 3 ticks
                metadata: {
                  slices: slice_bounds_for_frame(slices_data, frame_index, frame_size)
                }
              }
            }
            apply_animation_direction! tag_frames, frame_tag_data.fetch(:direction)
            result[tag.to_sym] = Animations.build(
              frames: tag_frames,
              **base
            )
          end
        }
      end

      def flipped_horizontally(animation)
        {
          base: animation[:base].merge(flip_horizontally: !animation[:base][:flip_horizontally]),
          frames: animation[:frames].map { |frame|
            flip_slices(frame, frame_width: animation[:base][:w])
          }
        }
      end

      private

      def build_base(sprite_sheet_data, path)
        frames = sprite_sheet_data.fetch :frames
        first_frame = frames.first.fetch :frame
        last_slash_index = path.rindex '/'
        {
          w: first_frame[:w],
          h: first_frame[:h],
          tile_w: first_frame[:w],
          tile_h: first_frame[:h],
          flip_horizontally: false,
          path: path[0..last_slash_index] + sprite_sheet_data.fetch(:meta).fetch(:image)
        }
      end

      def slice_bounds_for_frame(slices_data, frame_index, frame_size)
        {}.tap { |slices|
          slices_data.each do |slice_data|
            name = slice_data.fetch(:name).to_sym
            key_frame = slice_data[:keys].select { |slice_key_data|
              slice_key_data.fetch(:frame) <= frame_index
            }.last
            slice_bounds = key_frame.fetch(:bounds).dup
            slice_bounds[:y] = frame_size[:h] - slice_bounds[:y] - slice_bounds[:h]
            slices[name] = slice_bounds
          end
        }
      end

      def apply_animation_direction!(frames, direction)
        case direction
        when 'pingpong'
          (frames.size - 2).downto(1) do |index|
            frames << frames[index]
          end
        end
      end

      def flip_slices(frame, frame_width:)
        frame.merge(
          metadata: {
            slices: frame[:metadata][:slices].transform_values { |bounds|
              bounds.merge(x: frame_width - bounds[:x] - bounds[:w])
            }
          }
        )
      end

      def deep_symbolize_keys!(value)
        case value
        when Hash
          symbolize_keys!(value)
          value.each_value do |hash_value|
            deep_symbolize_keys!(hash_value)
          end
        when Array
          value.each do |array_value|
            deep_symbolize_keys!(array_value)
          end
        end

        value
      end

      def symbolize_keys!(hash)
        hash.each_key do |key|
          next unless key.is_a? String

          hash[key.to_sym] = hash.delete(key)
        end
        hash
      end
    end
  end
end
