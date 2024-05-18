class_name Game extends Node2D

@onready var platformParent: Node2D = $PlatformParent

var cameraScene: PackedScene = preload("res://scenes/game_camera.tscn")
var platformScene: PackedScene = preload("res://scenes/platform.tscn")

var camera: GameCamera = null

func _ready()-> void:
	camera = cameraScene.instantiate()
	camera.setupCamera($Player)
	add_child(camera)
	
	createPlatform(Vector2(100.0, 300.0))
	createPlatform(Vector2(100.0, 500.0))
	createPlatform(Vector2(100.0, 800.0))

func _process(_delta: float)-> void:
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()

func createPlatform(location: Vector2)-> Platform:
	var platform: Platform = platformScene.instantiate()
	platform.global_position = location
	platformParent.add_child(platform)
	
	return platform
