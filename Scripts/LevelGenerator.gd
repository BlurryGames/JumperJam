class_name LevelGenerator extends Node2D

@onready var platformParent: Node2D = $PlatformParent

var platformScene: PackedScene = preload("res://scenes/platform.tscn")

var player: Player = null

var viewportSize: Vector2 = Vector2.ZERO

var startPlatformY: float = 0.0
var yDistanceBetweenPlatforms: float = 100.0

var levelSize: int = 50
var generatedPlatformCount: int = 0

func _ready()-> void:
	viewportSize = get_viewport_rect().size
	generatedPlatformCount = 0
	startPlatformY = viewportSize.y - (yDistanceBetweenPlatforms * 2.0)

func _process(_delta: float)-> void:
	if player:
		var playerPositionY: float = player.global_position.y
		var endOfLevelPosition: float = startPlatformY - (generatedPlatformCount * yDistanceBetweenPlatforms)
		var threshold: float = endOfLevelPosition + (yDistanceBetweenPlatforms * 6.0)
		if playerPositionY <= threshold:
			generateLevel(endOfLevelPosition, false)

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

func setup(_player: Player)-> void:
	if _player:
		player = _player

func startGeneration()-> void:
	generateLevel(startPlatformY, true)
