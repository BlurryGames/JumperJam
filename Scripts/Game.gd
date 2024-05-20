class_name Game extends Node2D

@onready var levelGenerator: LevelGenerator = $LevelGenerator
@onready var groundSprite: Sprite2D = $GroundSprite
@onready var parallax1: ParallaxLayer = $ParallaxBackground/ParallaxLayer
@onready var parallax2: ParallaxLayer = $ParallaxBackground/ParallaxLayer2
@onready var parallax3: ParallaxLayer = $ParallaxBackground/ParallaxLayer3
@onready var hud: HUD = $LayerUI/HUD

var playerScene: PackedScene = preload("res://scenes/player.tscn")
var cameraScene: PackedScene = preload("res://scenes/game_camera.tscn")

var player: Player = null
var camera: GameCamera = null

var viewportSize: Vector2 = Vector2.ZERO
var playerSpawnPosition: Vector2 = Vector2.ZERO

func _ready()-> void:
	viewportSize = get_viewport_rect().size
	
	var playerSpawnPositionOffsetY: float = 135.0
	playerSpawnPosition.x = viewportSize.x * 0.5
	playerSpawnPosition.y = viewportSize.y - playerSpawnPositionOffsetY
	
	groundSprite.global_position.x = viewportSize.x * 0.5
	groundSprite.global_position.y = viewportSize.y
	
	setupParallaxLayer(parallax1)
	setupParallaxLayer(parallax2)
	setupParallaxLayer(parallax3)
	
	hud.visible = false


func _process(_delta: float)-> void:
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()

func _on_player_died()-> void:
	print("die")

func getParallaxSpriteScale(parallaxSprite: Sprite2D)-> Vector2:
	var parallaxTexture: Texture2D = parallaxSprite.get_texture()
	var parallaxTextureWidth: int = parallaxTexture.get_width()
	
	var widthScale: float = viewportSize.x / parallaxTextureWidth
	var result: Vector2 = Vector2(widthScale, widthScale)
	
	return result

func setupParallaxLayer(parallaxLayer: ParallaxLayer)-> void:
	var parallaxSprite: Sprite2D = parallaxLayer.find_child("Sprite2D")
	if parallaxSprite:
		parallaxSprite.scale = getParallaxSpriteScale(parallaxSprite)
		var mirroringY: float = parallaxSprite.scale.y * parallaxSprite.get_texture().get_height()
		parallaxLayer.motion_mirroring.y = mirroringY

func newGame()-> void:
	player = playerScene.instantiate()
	player.global_position = playerSpawnPosition
	player.died.connect(_on_player_died)
	add_child(player)
	
	camera = cameraScene.instantiate()
	camera.setupCamera(player)
	add_child(camera)
	
	if player:
		levelGenerator.setup(player)
		levelGenerator.startGeneration()
	
	hud.visible = true
