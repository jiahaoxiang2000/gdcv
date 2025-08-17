extends MeshInstance3D
class_name Slide

var slide_data: SlideData
var slide_index: int = 0
var material_instance: StandardMaterial3D

signal slide_loaded()

func _ready():
	create_slide_geometry()
	setup_material()

func create_slide_geometry():
	var quad_mesh = QuadMesh.new()
	quad_mesh.size = Vector2(8, 6)
	mesh = quad_mesh

func setup_material():
	material_instance = StandardMaterial3D.new()
	material_instance.albedo_color = Color.WHITE
	material_instance.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material_instance.cull_mode = BaseMaterial3D.CULL_DISABLED
	
	# Only set surface material if mesh has surfaces
	if mesh and mesh.get_surface_count() > 0:
		set_surface_override_material(0, material_instance)

func setup(data: SlideData, index: int):
	slide_data = data
	slide_index = index
	load_slide_content()

func load_slide_content():
	if not slide_data:
		return
	
	# Ensure geometry is created first
	if not mesh:
		create_slide_geometry()
	
	if not material_instance:
		setup_material()
	
	match slide_data.type:
		SlideData.SlideType.TEXT:
			load_text_slide()
		SlideData.SlideType.IMAGE:
			load_image_slide()
		SlideData.SlideType.MIXED:
			load_mixed_slide()

func load_text_slide():
	var texture = create_text_texture()
	if material_instance and texture:
		material_instance.albedo_texture = texture
	slide_loaded.emit()

func load_image_slide():
	if slide_data.image_path and ResourceLoader.exists(slide_data.image_path):
		var texture = load(slide_data.image_path) as Texture2D
		if texture and material_instance:
			material_instance.albedo_texture = texture
	slide_loaded.emit()

func load_mixed_slide():
	var texture = create_mixed_texture()
	if material_instance and texture:
		material_instance.albedo_texture = texture
	slide_loaded.emit()

func create_text_texture() -> ImageTexture:
	var img = Image.create(1024, 768, false, Image.FORMAT_RGBA8)
	img.fill(slide_data.background_color)
	
	var texture = ImageTexture.new()
	texture.set_image(img)
	return texture

func create_mixed_texture() -> ImageTexture:
	var img = Image.create(1024, 768, false, Image.FORMAT_RGBA8)
	img.fill(slide_data.background_color)
	
	var texture = ImageTexture.new()
	texture.set_image(img)
	return texture


func animate_in():
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector3.ONE, 0.5)
	tween.parallel().tween_property(material_instance, "albedo_color:a", 1.0, 0.5)

func animate_out():
	var tween = create_tween()
	tween.parallel().tween_property(self, "scale", Vector3(0.8, 0.8, 0.8), 0.3)
	tween.parallel().tween_property(material_instance, "albedo_color:a", 0.7, 0.3)
