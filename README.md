# GDCV - Godot Video Creation

A Godot-based project for creating videos using the Godot game engine.

## Overview

GDCV leverages Godot's powerful rendering capabilities and scripting system to create videos programmatically. This project provides a framework for generating animated content, motion graphics, and video sequences using Godot's scene system.

## Features

- **3D Scene-based Slide Creation**: Position slides in 3D space for cinematic presentations
- **Advanced Camera Movements**: Smooth transitions, orbit, dolly, zoom effects
- **Multiple Transition Types**: Linear, smooth, cinematic, zoom out/in transitions
- **Flexible Content System**: Support for text and image slides
- **Video Export Pipeline**: Frame-by-frame capture for video generation
- **Real-time Preview**: Interactive navigation with arrow keys
- Godot 4.4 compatibility

## Getting Started

### Prerequisites

- Godot 4.4 or later
- Basic knowledge of Godot and GDScript

### Installation

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd gdcv
   ```

2. Open the project in Godot:
   - Launch Godot
   - Click "Import" and select the `project.godot` file
   - Click "Import & Edit"

### Usage

1. **Basic Demo**: Run the project to see the demo presentation with 3 sample slides
2. **Navigation**: Use arrow keys to navigate between slides
   - Left/Up: Previous slide  
   - Right/Down: Next slide
   - Enter: Restart presentation

3. **Creating Custom Presentations**:
   ```gdscript
   # Create presentation data
   var presentation = PresentationData.new()
   presentation.title = "My Presentation"
   
   # Create slides
   var slide = SlideData.new()
   slide.type = SlideData.SlideType.TEXT
   slide.title = "Slide Title"
   slide.content = "Slide content"
   slide.background_color = Color.BLUE
   
   presentation.slides.append(slide)
   
   # Load into slide manager
   slide_manager.load_presentation(presentation)
   slide_manager.start_presentation()
   ```

4. **Camera Transitions**: The system includes several transition types:
   - Linear, Smooth, Cinematic
   - Zoom Out/In, Orbit, Dolly movements

5. **Video Export**: Use VideoExporter to capture presentations as video frames

## Project Structure

```
gdcv/
├── project.godot              # Godot project configuration
├── slide/                    # Complete slide system
│   ├── slide.tscn            # Main 3D scene with camera and lighting
│   ├── MainScene.gd          # Demo scene controller
│   ├── SlideManager.gd       # Core slide system controller
│   ├── Slide.gd              # Individual slide rendering logic
│   ├── CameraDirector.gd     # Camera movement and transitions
│   ├── PresentationData.gd   # Presentation data structure
│   ├── SlideData.gd          # Individual slide data structure
│   ├── PresentationSettings.gd # Presentation configuration
│   ├── VideoExporter.gd      # Video output pipeline
│   └── ExamplePresentation.gd # Sample presentation creator
├── icon.svg                  # Project icon
├── README.md                 # This file
└── CHANGELOG.md              # Version history
```

## Development

This project is built with:
- **Engine**: Godot 4.4
- **Rendering**: Forward Plus (3D scenes)
- **Scripting**: GDScript
- **Architecture**: 3D positioning for 2D slide content

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

[Add your license information here]

## Support

For questions and support, please [create an issue](../../issues) in this repository.
