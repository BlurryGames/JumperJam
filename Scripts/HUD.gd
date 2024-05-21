class_name HUD extends Control

@onready var topBar: Control = $TopBar
@onready var topBarBackground: ColorRect = $TopBarBackground
@onready var scoreLabel: Label = $TopBar/ScoreLabel

func _ready()-> void:
	var osName: String = OS.get_name()
	
	if osName == "Android" or osName == "iOS":
		var safeArea: Rect2i = DisplayServer.get_display_safe_area()
		var safeAreaTop: int = safeArea.position.y
		
		if osName == "iOS":
			var screenScale: float = DisplayServer.screen_get_scale()
			safeAreaTop /= screenScale
			
			UtilityPtr.addLogMessage("Screen scale: " + str(screenScale))
		
		topBar.position.y += safeAreaTop
		var margin: int = 10
		topBarBackground.size.y += safeAreaTop + margin
		
		UtilityPtr.addLogMessage("Safe area: " + str(safeArea))
		UtilityPtr.addLogMessage("Window size: " + str(DisplayServer.window_get_size()))
		UtilityPtr.addLogMessage("Safe area top: " + str(safeAreaTop))
		UtilityPtr.addLogMessage("Top bar position: " + str(topBar.position))

func _on_pause_button_pressed()-> void:
	pass

func setScore(newScore: int)-> void:
	scoreLabel.text = str(newScore)
