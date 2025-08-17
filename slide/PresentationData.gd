extends Resource
class_name PresentationData

@export var title: String = ""
@export var author: String = ""
@export var slides: Array[SlideData] = []
@export var settings: PresentationSettings

func _init():
	settings = PresentationSettings.new()

func add_slide(slide: SlideData):
	slides.append(slide)

func get_slide_count() -> int:
	return slides.size()

func get_slide(index: int) -> SlideData:
	if index >= 0 and index < slides.size():
		return slides[index]
	return null

func load_from_file(file_path: String) -> bool:
	if ResourceLoader.exists(file_path):
		var data = load(file_path) as PresentationData
		if data:
			title = data.title
			author = data.author
			slides = data.slides
			settings = data.settings
			return true
	return false

func save_to_file(file_path: String) -> bool:
	return ResourceSaver.save(self, file_path) == OK

