extends Resource
class_name PresentationSettings

@export var slide_width: float = 8.0
@export var slide_height: float = 6.0
@export var slide_spacing: float = 12.0
@export var default_transition_duration: float = 1.0
@export var camera_movement_speed: float = 2.0
@export var video_resolution: Vector2i = Vector2i(1920, 1080)
@export var video_fps: int = 30
@export var auto_advance: bool = false
@export var loop_presentation: bool = false

func _init():
	slide_width = 8.0
	slide_height = 6.0
	slide_spacing = 12.0