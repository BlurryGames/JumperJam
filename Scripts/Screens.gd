class_name Screens extends CanvasLayer

@onready var console: Control = $Debug/ConsoleLog

func _ready()-> void:
	console.visible = false
	
	registerButtons()

func _on_toggle_console_pressed()-> void:
	console.visible = not console.visible

func _on_button_pressed(button: TextureButton)-> void:
	match button.name:
		"TitlePlay":
			print("PlayPress")
		"PauseRetry":
			print("PauseRetryPress")
		"PauseBack":
			print("PauseBackPress")
		"PauseClose":
			print("PauseClosePress")
		"GameOverRetry":
			print("GameOverRetryPress")
		"GameOverBack":
			print("GameOverBackPress")

func registerButtons()-> void:
	var buttons: Array[Node] = get_tree().get_nodes_in_group("Buttons")
	if buttons.size() > 0:
		for b: Node in buttons:
			if b is ScreenButton:
				b.clicked.connect(_on_button_pressed)
