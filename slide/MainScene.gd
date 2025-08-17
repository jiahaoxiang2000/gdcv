extends Node3D

@onready var slide_manager = $SlideManager

func _ready():
	await get_tree().process_frame
	load_demo_presentation()

func load_demo_presentation():
	var presentation: PresentationData = PresentationData.new()
	presentation.title = "GDCV Demo"
	presentation.author = "Demo Author"
	
	var slide1 = SlideData.new()
	slide1.type = SlideData.SlideType.TEXT
	slide1.title = "Slide 1"
	slide1.content = "Welcome to GDCV"
	slide1.background_color = Color.BLUE
	
	var slide2 = SlideData.new()
	slide2.type = SlideData.SlideType.TEXT
	slide2.title = "Slide 2"
	slide2.content = "3D Slide Presentation"
	slide2.background_color = Color.GREEN
	
	var slide3 = SlideData.new()
	slide3.type = SlideData.SlideType.TEXT
	slide3.title = "Slide 3"
	slide3.content = "Built with Godot"
	slide3.background_color = Color.RED
	
	presentation.slides = [slide1, slide2, slide3]
	slide_manager.load_presentation(presentation)
	slide_manager.start_presentation()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		print("[MainScene] Key pressed: ENTER/SPACE")
		if slide_manager.slides.is_empty():
			print("[MainScene] Loading demo presentation")
			load_demo_presentation()
		else:
			print("[MainScene] Restarting presentation")
			slide_manager.start_presentation()
