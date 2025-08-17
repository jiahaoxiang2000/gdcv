# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Complete 3D slide presentation system implementation
- Main 3D scene with Camera3D, directional lighting, and slide container
- SlideManager.gd for core slide system management and navigation
- Slide.gd class extending MeshInstance3D with quad geometry for slide rendering
- CameraDirector.gd with advanced camera movements and transition effects
  - Linear, smooth, cinematic transitions
  - Zoom out/in, orbit, and dolly camera movements
- PresentationData.gd, SlideData.gd, and PresentationSettings.gd data structures
- VideoExporter.gd for frame-by-frame video capture and export
- MainScene.gd demo controller with sample presentation
- ExamplePresentation.gd for creating sample presentations
- Interactive navigation with arrow keys (left/right, up/down for slide navigation)
- Support for text slides with customizable colors and content
- Real-time preview and presentation mode
- Comprehensive project documentation and usage examples

### Changed

- Updated project.godot to use main_scene.tscn as main scene
- Enhanced README.md with detailed usage instructions and project structure
- Improved CHANGELOG.md with comprehensive feature documentation
- Organized all slide system components into `slide/` folder for better code structure
- Moved main_scene.tscn to slide/slide.tscn for complete system encapsulation
- Updated scene file references to use new folder paths
- Updated project.godot to use slide/slide.tscn as main scene

### Deprecated

### Removed

### Fixed

- Fixed multiple GDScript errors and warnings across the slide system:
  - Property assignment error in MainScene.gd by adding explicit type annotation
  - Shadowed variable warning in Slide.gd by renaming parameter from 'visible' to 'is_visible'
  - Added emission logic for unused signal 'presentation_ended' in SlideManager.gd
  - Fixed null parameter error in CameraDirector.gd with proper null checks
  - Fixed albedo_texture assignment error by ensuring material initialization
  - Fixed deprecated 'unshaded' property by using 'shading_mode' instead
  - Fixed surface material index out of bounds error with proper bounds checking
- Enhanced error handling and null checks throughout the slide system
- Improved initialization order and material setup for better stability
- Added comprehensive input mapping to project.godot for presentation controls
- Enhanced debugging capabilities with detailed logging for key presses and slide navigation
- Added camera movement debugging logs and enhanced error reporting
- Improved state tracking and validation across all slide system components

### Security
