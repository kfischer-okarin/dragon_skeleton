module DragonSkeleton
  module FileFormats
    module AsepriteJson
      class << self
        # Reads an Aseprite Spritesheet JSON data file and returns a hash of animations.
        # The JSON file must have been exported as Array with Tags and Slices enabled.
        def read_as_animations(asesprite_json_path)
          sprite_sheet_data = deep_symbolize_keys! $gtk.parse_json_file(asesprite_json_path)

          path = sprite_path(sprite_sheet_data, asesprite_json_path)

          {}.tap { |result|
            frames = sprite_sheet_data.fetch :frames
            slices_data = sprite_sheet_data.fetch(:meta).fetch :slices

            sprite_sheet_data.fetch(:meta).fetch(:frameTags).each do |frame_tag_data|
              tag = frame_tag_data.fetch(:name).to_sym
              frame_range = frame_tag_data.fetch(:from)..frame_tag_data.fetch(:to)
              tag_frames = frame_range.map { |frame_index|
                frame_data = frames[frame_index]
                frame = frame_data.fetch(:frame)
                {
                  path: path,
                  w: frame[:w],
                  h: frame[:h],
                  tile_x: frame[:x],
                  tile_y: frame[:y],
                  tile_w: frame[:w],
                  tile_h: frame[:h],
                  flip_horizontally: false,
                  duration: frame_data.fetch(:duration).idiv(50) * 3, # 50ms = 3 ticks
                  metadata: {
                    slices: slice_bounds_for_frame(slices_data, frame_index, frame.slice(:w, :h))
                  }
                }
              }
              apply_animation_direction! tag_frames, frame_tag_data.fetch(:direction)
              result[tag.to_sym] = Animations.build(frames: tag_frames)
            end
          }
        end

        def flipped_horizontally(animation)
          {
            frames: animation[:frames].map { |frame|
              values = frame[:values]
              frame.merge(
                values: values.merge(flip_horizontally: !values[:flip_horizontally]),
                metadata: {
                  slices: frame[:metadata][:slices].transform_values { |bounds|
                    bounds.merge(x: values[:w] - bounds[:x] - bounds[:w])
                  }
                }
              )
            }
          }
        end

        private

        def sprite_path(sprite_sheet_data, asesprite_json_path)
          last_slash_index = asesprite_json_path.rindex '/'
          asesprite_json_path[0..last_slash_index] + sprite_sheet_data.fetch(:meta).fetch(:image)
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
end
