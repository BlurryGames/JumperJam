class_name Game extends Node2D

signal playerDied(score: int, hightScore: int)

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

var saveFilePath: String = "user://highscore.save"

var viewportSize: Vector2 = Vector2.ZERO
var playerSpawnPosition: Vector2 = Vector2.ZERO

var score: int = 0
var highScore: int = 0

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
	hud.setScore(0)
	groundSprite.visible = false
	
	loadScore()

func _process(_delta: float)-> void:
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()
	
	if player:
		var altitude: int = viewportSize.y - player.global_position.y
		if score < altitude:
			score = altitude
			hud.setScore(score)

func _on_player_died()-> void:
	hud.visible = false
	
	if score > highScore:
		highScore = score
		saveScore()
	
	playerDied.emit(score, highScore)

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
	resetGame()
	
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
	groundSprite.visible = true
	score = 0

func resetGame()-> void:
	groundSprite.visible = false
	hud.setScore(0)
	levelGenerator.resetLevel()
	if player:
		player.queue_free()
		player = null
		levelGenerator.player = null
	
	if camera:
		camera.queue_free()
		camera = null

func saveScore()-> void:
	var file: FileAccess = FileAccess.open(saveFilePath, FileAccess.WRITE)
	file.store_var(highScore)
	file.close()

func loadScore()-> void:
	if FileAccess.file_exists(saveFilePath):
		var file: FileAccess = FileAccess.open(saveFilePath, FileAccess.READ)
		highScore = file.get_var()
		file.close()
	else:
		highScore = 0
