class_name Game extends Node2D

@onready var platformParent: Node2D = $PlatformParent

var cameraScene: PackedScene = preload("res://scenes/game_camera.tscn")
var platformScene: PackedScene = preload("res://scenes/platform.tscn")

var camera: GameCamera = null

var viewportSize: Vector2 = Vector2.ZERO

var startPlatformY: float = 0.0
var yDistanceBetweenPlatforms: float = 100.0

var levelSize: int = 50
var generatedPlatformCount: int = 0

func _ready()-> void:
	camera = cameraScene.instantiate()
	camera.setupCamera($Player)
	add_child(camera)
	
	viewportSize = get_viewport_rect().size
	generatedPlatformCount = 0
	startPlatformY = viewportSize.y - (yDistanceBetweenPlatforms * 2.0)
	generateLevel(startPlatformY, true)

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

func generateLevel(startY: float, generateGround: bool)-> void:
	var platformWidth: float = 136.0
	
	if generateGround:
		var groundLayerPlatformCount: float = (viewportSize.x / platformWidth) + 1.0
		var groundLayerOffsetY: float = 62.0
		for i: int in range(groundLayerPlatformCount):
			var groundLocation: Vector2 = Vector2(i * platformWidth, viewportSize.y - groundLayerOffsetY)
			createPlatform(groundLocation)
	
	for i: int in range(levelSize):
		var maxPositionX = viewportSize.x - platformWidth
		var randomX = randf_range(0.0, maxPositionX)
		var location: Vector2 = Vector2.ZERO
		location.x = randomX
		location.y = startY - (yDistanceBetweenPlatforms * i)
		createPlatform(location)
		generatedPlatformCount += 1
