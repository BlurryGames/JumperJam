class_name Game extends Node2D

@onready var levelGenerator: LevelGenerator = $LevelGenerator
@onready var player: Player = $Player

var cameraScene: PackedScene = preload("res://scenes/game_camera.tscn")

var camera: GameCamera = null

func _ready()-> void:
	camera = cameraScene.instantiate()
	camera.setupCamera($Player)
	add_child(camera)
	
	if player:
		levelGenerator.setup(player)

func _process(_delta: float)-> void:
	if Input.is_action_just_pressed("Quit"):
		get_tree().quit()
	elif Input.is_action_just_pressed("Reset"):
		get_tree().reload_current_scene()
