extends Node
class_name VideoExporter

var slide_manager: SlideManager
var is_recording: bool = false
var output_path: String = ""
var frame_count: int = 0
var fps: int = 30
var resolution: Vector2i = Vector2i(1920, 1080)

signal export_started()
signal export_progress(frame: int, total_frames: int)
signal export_completed(file_path: String)
signal export_failed(error: String)

func _ready():
	slide_manager = get_node("../SlideManager") if get_parent().has_node("SlideManager") else null

func start_video_export(presentation: PresentationData, output_file: String):
	if is_recording:
		export_failed.emit("Already recording")
		return
	
	if not presentation or presentation.slides.is_empty():
		export_failed.emit("No presentation data or slides")
		return
	
	output_path = output_file
	is_recording = true
	frame_count = 0
	
	setup_recording()
	export_started.emit()
	
	await record_presentation(presentation)

func setup_recording():
	var viewport = get_viewport()
	viewport.size = resolution
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS

func record_presentation(presentation: PresentationData):
	if not slide_manager:
		export_failed.emit("SlideManager not found")
		return
	
	slide_manager.load_presentation(presentation)
	
	var total_frames = calculate_total_frames(presentation)
	var frames_captured: Array[Image] = []
	
	for slide_index in range(presentation.slides.size()):
		slide_manager.go_to_slide(slide_index)
		await get_tree().process_frame
		await get_tree().process_frame
		
		var slide_data = presentation.slides[slide_index]
		var slide_frames = int(slide_data.duration * fps)
		
		for frame in range(slide_frames):
			var image = await capture_frame()
			if image:
				frames_captured.append(image)
				frame_count += 1
				export_progress.emit(frame_count, total_frames)
			
			await get_tree().process_frame
		
		if slide_index < presentation.slides.size() - 1:
			var transition_frames = int(presentation.settings.default_transition_duration * fps)
			for frame in range(transition_frames):
				var image = await capture_frame()
				if image:
					frames_captured.append(image)
					frame_count += 1
					export_progress.emit(frame_count, total_frames)
				
				await get_tree().process_frame
	
	await save_frames_as_video(frames_captured, output_path)

func capture_frame() -> Image:
	var viewport = get_viewport()
	await RenderingServer.frame_post_draw
	var image = viewport.get_texture().get_image()
	return image

func calculate_total_frames(presentation: PresentationData) -> int:
	var total = 0
	for slide_data in presentation.slides:
		total += int(slide_data.duration * fps)
	
	total += int(presentation.settings.default_transition_duration * fps) * (presentation.slides.size() - 1)
	return total

func save_frames_as_video(frames: Array[Image], file_path: String):
	if frames.is_empty():
		export_failed.emit("No frames captured")
		return
	
	var base_path = file_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(base_path):
		DirAccess.make_dir_recursive_absolute(base_path)
	
	for i in range(frames.size()):
		var frame_path = base_path + "/frame_%06d.png" % i
		frames[i].save_png(frame_path)
	
	await create_video_from_frames(base_path, file_path)

func create_video_from_frames(frames_dir: String, output_file: String):
	print("Frames saved to: ", frames_dir)
	print("To create video, run:")
	print("ffmpeg -framerate %d -i \"%s/frame_%%06d.png\" -c:v libx264 -pix_fmt yuv420p \"%s\"" % [fps, frames_dir, output_file])
	
	is_recording = false
	export_completed.emit(output_file)

func stop_recording():
	if is_recording:
		is_recording = false
		export_failed.emit("Recording stopped by user")

func set_export_settings(new_fps: int, new_resolution: Vector2i):
	fps = new_fps
	resolution = new_resolution

func get_export_progress() -> float:
	if not is_recording:
		return 0.0
	return 0.0