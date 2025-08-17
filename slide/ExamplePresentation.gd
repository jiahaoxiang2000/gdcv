extends Node

func create_sample_presentation() -> PresentationData:
	var presentation = PresentationData.new()
	presentation.title = "GDCV Demo Presentation"
	presentation.author = "GDCV System"
	
	var slide1 = SlideData.new()
	slide1.type = SlideData.SlideType.TEXT
	slide1.title = "Welcome to GDCV"
	slide1.content = "3D Scene-based Video Creation"
	slide1.background_color = Color.DARK_BLUE
	slide1.text_color = Color.WHITE
	
	var slide2 = SlideData.new()
	slide2.type = SlideData.SlideType.TEXT
	slide2.title = "Features"
	slide2.content = "• Cinematic camera movements\n• 3D slide positioning\n• Professional transitions"
	slide2.background_color = Color.DARK_GREEN
	slide2.text_color = Color.WHITE
	
	var slide3 = SlideData.new()
	slide3.type = SlideData.SlideType.TEXT
	slide3.title = "Built with Godot"
	slide3.content = "Leveraging Godot 4.4's powerful 3D engine"
	slide3.background_color = Color.PURPLE
	slide3.text_color = Color.WHITE
	
	presentation.slides = [slide1, slide2, slide3]
	return presentation

func load_sample_presentation(slide_manager: SlideManager):
	var presentation = create_sample_presentation()
	slide_manager.load_presentation(presentation)
	slide_manager.start_presentation()