extends Resource
class_name SlideData

enum SlideType {
	TEXT,
	IMAGE,
	MIXED
}

@export var type: SlideType = SlideType.TEXT
@export var title: String = ""
@export var content: String = ""
@export var image_path: String = ""
@export var background_color: Color = Color.WHITE
@export var text_color: Color = Color.BLACK
@export var font_size: int = 24
@export var duration: float = 5.0
@export var transition_type: String = "fade"
@export var position_3d: Vector3 = Vector3.ZERO
@export var rotation_3d: Vector3 = Vector3.ZERO
@export var scale_3d: Vector3 = Vector3.ONE

func _init():
	type = SlideType.TEXT