class_name Game extends Node2D

var cameraScene: PackedScene = preload("res://scenes/game_camera.tscn")

var camera: GameCamera = null

func _ready()-> void:
	camera = cameraScene.instantiate()
	camera.setupCamera($Player)
	add_child(camera)
