class_name Screens extends CanvasLayer

@onready var console: Control = $Debug/ConsoleLog

func _ready()-> void:
	console.visible = false

func _on_toggle_console_pressed()-> void:
	console.visible = not console.visible
