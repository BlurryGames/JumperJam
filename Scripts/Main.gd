class_name Main extends Node

@onready var game: Game = $Game
@onready var screens: Screens = $Screens

func _ready()-> void:
	screens.startGame.connect(_on_screens_start_game)

func _on_screens_start_game()-> void:
	game.newGame()
