# Changelog

This project does **not** use Semantic Versioning but just has versions tagged with the date when they were released.
Otherwise it more or less follows [Common Changelog] format.

## [2023.04.04.1]

### Added
- Added `Set`

## [2023.03.14.1]

### Added
- Added `Tilemap#w` and `Tilemap#h`

### Fixed
- Ignore unknown properties passed to `Tilemap::Cell#assign` instead of raising an error

## [2023.03.01.1]

### Added
- Added `Tilemap#to_grid_coordinates` and `Tilemap#cell_rect` methods (cfeec2c)

### Fixed
- Fixed swapped documentation for `Tilemap` attributes (d46347d)

## [2023.02.23.1]

### Changed
- Skip value assignment if assigned tile id is same as before (2e8cc63)

## [2023.02.17.2]

### Added
- Added `assign` method to `Tilemap` cell for multi assignment of several properties (5347f35)
- Allow specifying a tileset object which associates tile ids with attributes to assign to a cell (4482b2f)

## [2023.02.17.1]

### Added
- Added `Tilemap` class (c5e7029...7da17a7)

## [2023.01.25.1]

*Renamed Library from **DR Base Framework** to **Dragon Skeleton***

### Changed
- **Breaking:** Moved all classes into `DragonSkeleton` module and provide `DragonSkeleton.add_to_top_level_namespace` to add modules to top level namespace (1c736a9)
- **Breaking:** Moved `Animations::Asesprite` module to `FileFormats::Aseprite` to include animation unrelated methods too - and the old name was a typo anyways (d5fc503, b959f16)
- **Breaking:** Renamed `Animations.flipped_horizontally` to `Animations.flip_animation_horizontally` (61deecd)
- **Breaking:** Renamed `Animations.animate` to `Animations.lerp` which is a more common name for what the method does (c009fd7)
- **Breaking:** Removed `AnimatedSprite` since it does not bring too much new value in addition to `Animations` (def2363)

### Added
- Added `FileFormats::Aseprite.read_as_sprites` (6b64121)
- Added `Buttons` module with `Buttons.handle_mouse_input` (e3b1a78)
- Added `LongCalculation` module (c715442...4ec953d)
- Added `Pathfinding::AStar` module (e5e690c...ef93c5b)
- Added `Screen` module (ef93c5b...f56c173)
- Added documentation to all existing modules and functions

### Removed
- **Breaking:** Removed base frame data from animations - the same effect can be accomplished when setting those properties on the first frame only (bf11bd1)

## [2022.12.13]

### Changed

- **Breaking:** Add `Animations.perform_tick` to be used instead of `Animations.next_tick` and `Animations.apply!` (496b243)
- **Breaking:** Rename `AnimatedSprite.update!` to `AnimatedSprite.perform_tick!` (46d0d85)

### Added

- Allow animations to have last frame without duration (770adda)
- Add `easing` key to animation frame (2a87918)
- Add `Animations.animate` as convencience method for animating an object property (da1255b)


## [2022.12.03]

*Initial release*

[Common Changelog]: https://common-changelog.org/
[2022.12.03]: https://github.com/kfischer-okarin/dragon_skeleton/releases/tag/2022.12.03
[2022.12.13]: https://github.com/kfischer-okarin/dragon_skeleton/releases/tag/2022.12.13
[2023.01.25.1]: https://github.com/kfischer-okarin/dragon_skeleton/releases/tag/2023.01.25.1
[2023.02.17.1]: https://github.com/kfischer-okarin/dragon_skeleton/releases/tag/2023.02.17.1
[2023.02.17.2]: https://github.com/kfischer-okarin/dragon_skeleton/releases/tag/2023.02.17.2
[2023.02.23.1]: https://github.com/kfischer-okarin/dragon_skeleton/releases/tag/2023.02.23.1
[2023.03.01.1]: https://github.com/kfischer-okarin/dragon_skeleton/releases/tag/2023.03.01.1
[2023.03.14.1]: https://github.com/kfischer-okarin/dragon_skeleton/releases/tag/2023.03.14.1
[2023.04.04.1]: https://github.com/kfischer-okarin/dragon_skeleton/releases/tag/2023.04.04.1
