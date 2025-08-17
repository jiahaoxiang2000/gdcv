extends Node3D
class_name CameraDirector

@onready var camera: Camera3D
var slide_manager: SlideManager

enum TransitionType {
	LINEAR,
	SMOOTH,
	CINEMATIC,
	ZOOM_OUT_IN,
	ORBIT,
	DOLLY
}

var current_transition_type: TransitionType = TransitionType.SMOOTH
var transition_duration: float = 1.0
var is_transitioning: bool = false

signal transition_started()
signal transition_completed()

func _ready():
	slide_manager = get_parent() as SlideManager
	if slide_manager:
		camera = slide_manager.camera_3d
		print("[CameraDirector] Initialized - Camera: ", camera != null, " SlideManager: ", slide_manager != null)

func move_to_slide(target_slide: Slide, transition_type: TransitionType = TransitionType.SMOOTH):
	if is_transitioning or not camera or not target_slide:
		return
	
	print("[CameraDirector] Starting camera transition: ", TransitionType.keys()[transition_type])
	current_transition_type = transition_type
	is_transitioning = true
	transition_started.emit()
	
	match transition_type:
		TransitionType.LINEAR:
			linear_transition(target_slide)
		TransitionType.SMOOTH:
			smooth_transition(target_slide)
		TransitionType.CINEMATIC:
			cinematic_transition(target_slide)
		TransitionType.ZOOM_OUT_IN:
			zoom_out_in_transition(target_slide)
		TransitionType.ORBIT:
			orbit_transition(target_slide)
		TransitionType.DOLLY:
			dolly_transition(target_slide)

func linear_transition(target_slide: Slide):
	if not camera or not target_slide:
		finish_transition()
		return
	var target_pos = calculate_camera_position(target_slide)
	var tween = create_tween()
	tween.tween_property(camera, "position", target_pos, transition_duration)
	tween.tween_callback(finish_transition)

func smooth_transition(target_slide: Slide):
	if not camera or not target_slide:
		finish_transition()
		return
	var target_pos = calculate_camera_position(target_slide)
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(camera, "position", target_pos, transition_duration)
	tween.tween_callback(finish_transition)

func cinematic_transition(target_slide: Slide):
	var start_pos = camera.position
	var target_pos = calculate_camera_position(target_slide)
	var mid_pos = (start_pos + target_pos) / 2.0 + Vector3(0, 3, 2)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUART)
	
	tween.tween_property(camera, "position", mid_pos, transition_duration * 0.6)
	tween.tween_property(camera, "position", target_pos, transition_duration * 0.4)
	tween.tween_callback(finish_transition)

func zoom_out_in_transition(target_slide: Slide):
	var start_pos = camera.position
	var target_pos = calculate_camera_position(target_slide)
	var zoom_out_pos = start_pos + Vector3(0, 0, 15)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	
	tween.tween_property(camera, "position", zoom_out_pos, transition_duration * 0.3)
	tween.tween_property(camera, "position", target_pos + Vector3(0, 0, 15), transition_duration * 0.4)
	tween.tween_property(camera, "position", target_pos, transition_duration * 0.3)
	tween.tween_callback(finish_transition)

func orbit_transition(target_slide: Slide):
	var target_pos = calculate_camera_position(target_slide)
	var slide_center = target_slide.global_position
	var radius = 10.0
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	
	for i in range(5):
		var angle = (i / 4.0) * PI * 0.5
		var orbit_pos = slide_center + Vector3(sin(angle) * radius, 2, cos(angle) * radius + 8)
		tween.tween_property(camera, "position", orbit_pos, transition_duration / 5.0)
		tween.tween_callback(func(): camera.look_at(slide_center, Vector3.UP))
	
	tween.tween_property(camera, "position", target_pos, transition_duration * 0.2)
	tween.tween_callback(finish_transition)

func dolly_transition(target_slide: Slide):
	var start_pos = camera.position
	var target_pos = calculate_camera_position(target_slide)
	
	var direction = (target_pos - start_pos).normalized()
	var dolly_distance = 20.0
	var dolly_start = start_pos - direction * dolly_distance
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	
	camera.position = dolly_start
	tween.tween_property(camera, "position", target_pos, transition_duration)
	tween.tween_callback(finish_transition)

func calculate_camera_position(slide: Slide) -> Vector3:
	return slide.global_position + Vector3(0, 1, 8)

func finish_transition():
	print("[CameraDirector] Camera transition completed")
	is_transitioning = false
	transition_completed.emit()

func set_transition_duration(duration: float):
	transition_duration = duration

func get_available_transitions() -> Array[String]:
	return ["linear", "smooth", "cinematic", "zoom_out_in", "orbit", "dolly"]

func pan_camera(direction: Vector3, distance: float, duration: float = 1.0):
	if is_transitioning:
		return
	
	var target_pos = camera.position + direction * distance
	var tween = create_tween()
	tween.tween_property(camera, "position", target_pos, duration)

func zoom_camera(zoom_factor: float, duration: float = 0.5):
	if is_transitioning:
		return
	
	var target_fov = camera.fov * zoom_factor
	target_fov = clamp(target_fov, 10, 120)
	
	var tween = create_tween()
	tween.tween_property(camera, "fov", target_fov, duration)