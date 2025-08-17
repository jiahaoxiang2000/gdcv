extends Node3D
class_name SlideManager

@onready var camera_3d = $Camera3D
@onready var slide_container = $SlideContainer
@onready var camera_director = $CameraDirector

var slide_scene = preload("res://slide/Slide.gd")

var slides: Array[Slide] = []
var current_slide_index: int = 0
var presentation_data: PresentationData

signal slide_changed(slide_index: int)
signal presentation_started()
signal presentation_ended()

func _ready():
	print("[SlideManager] Initializing - Camera3D: ", camera_3d != null, " CameraDirector: ", camera_director != null)
	setup_environment()

func setup_environment():
	var env = Environment.new()
	env.background_mode = Environment.BG_COLOR
	env.background_color = Color(0.1, 0.1, 0.1, 1.0)
	env.ambient_light_color = Color(0.3, 0.3, 0.3, 1.0)
	env.ambient_light_energy = 0.5
	
	var world_env = get_viewport().world_3d.environment
	if not world_env:
		get_viewport().world_3d.environment = env

func load_presentation(data: PresentationData):
	presentation_data = data
	clear_slides()
	create_slides()

func clear_slides():
	for slide in slides:
		if slide:
			slide.queue_free()
	slides.clear()

func create_slides():
	if not presentation_data:
		return
	
	for i in range(presentation_data.slides.size()):
		var slide_data = presentation_data.slides[i]
		var slide = Slide.new()
		slide.setup(slide_data, i)
		slide_container.add_child(slide)
		slides.append(slide)
		
		position_slide(slide, i)

func position_slide(slide: Slide, index: int):
	var spacing = 12.0
	slide.position = Vector3(index * spacing, 0, 0)

func go_to_slide(index: int):
	if index < 0 or index >= slides.size():
		print("[SlideManager] Invalid slide index: ", index, " (total slides: ", slides.size(), ")")
		return
	
	print("[SlideManager] Moving to slide ", index + 1, "/", slides.size())
	current_slide_index = index
	slide_changed.emit(index)
	
	var target_position = slides[index].position + Vector3(0, 0, 8)
	move_camera_to_position(target_position)

func next_slide():
	if current_slide_index >= slides.size() - 1:
		print("[SlideManager] Reached end of presentation")
		presentation_ended.emit()
	else:
		go_to_slide(current_slide_index + 1)

func previous_slide():
	if current_slide_index <= 0:
		print("[SlideManager] Already at first slide")
		return
	go_to_slide(current_slide_index - 1)

func move_camera_to_position(target_pos: Vector3):
	print("[SlideManager] Moving camera to position: ", target_pos)
	if camera_director and camera_director.camera:
		print("[SlideManager] Using camera director for transition")
		camera_director.move_to_slide(slides[current_slide_index])
	elif camera_3d:
		print("[SlideManager] Using direct camera tween")
		var tween = create_tween()
		tween.tween_property(camera_3d, "position", target_pos, 1.0)
		tween.tween_callback(func(): print("[SlideManager] Camera moved to slide ", current_slide_index + 1))
	else:
		print("[SlideManager] ERROR: No camera available for movement!")

func start_presentation():
	if slides.is_empty():
		print("[SlideManager] No slides loaded")
		return
	
	print("[SlideManager] Starting presentation with ", slides.size(), " slides")
	presentation_started.emit()
	go_to_slide(0)

func _input(event):
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_down"):
		print("[SlideManager] Key pressed: RIGHT/DOWN - Moving to next slide")
		next_slide()
	elif event.is_action_pressed("ui_left") or event.is_action_pressed("ui_up"):
		print("[SlideManager] Key pressed: LEFT/UP - Moving to previous slide")
		previous_slide()