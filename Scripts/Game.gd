class_name Game extends Node2D

@onready var platformParent: Node2D = $PlatformParent

var cameraScene: PackedScene = preload("res://scenes/game_camera.tscn")
var platformScene: PackedScene = preload("res://scenes/platform.tscn")

var camera: GameCamera = null

func _ready()-> void:
	camera = cameraScene.instantiate()
	camera.setupCamera($Player)
	add_child(camera)
	
	var viewportSize: Vector2 = get_viewport_rect().size
	var platformWidth: float = 136.0
	var groundLayerPlatformCount: float = (viewportSize.x / platformWidth) + 1.0
	
	var groundLayerOffsetY: float = 62.0
	for i: int in range(groundLayerPlatformCount):
		var groundLocation: Vector2 = Vector2(i * platformWidth, viewportSize.y - groundLayerOffsetY)
		createPlatform(groundLocation)

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
