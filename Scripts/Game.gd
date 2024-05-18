class_name Game extends Node2D

@onready var levelGenerator: LevelGenerator = $LevelGenerator
@onready var groundSprite: Sprite2D = $GroundSprite

var playerScene: PackedScene = preload("res://scenes/player.tscn")
var cameraScene: PackedScene = preload("res://scenes/game_camera.tscn")

var player: Player = null
var camera: GameCamera = null

var playerSpawnPosition: Vector2 = Vector2.ZERO

func _ready()-> void:
	var viewportSize: Vector2 = get_viewport_rect().size
	
	var playerSpawnPositionOffsetY: float = 135.0
	playerSpawnPosition.x = viewportSize.x * 0.5
	playerSpawnPosition.y = viewportSize.y - playerSpawnPositionOffsetY
	
	groundSprite.global_position.x = viewportSize.x * 0.5
	groundSprite.global_position.y = viewportSize.y
	
	newGame()


func _process(_delta: float)-> void:
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()

func newGame()-> void:
	player = playerScene.instantiate()
	player.global_position = playerSpawnPosition
	add_child(player)
	
	camera = cameraScene.instantiate()
	camera.setupCamera(player)
	add_child(camera)
	
	if player:
		levelGenerator.setup(player)
