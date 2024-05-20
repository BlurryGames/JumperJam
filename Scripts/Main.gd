class_name Main extends Node

@onready var game: Game = $Game
@onready var screens: Screens = $Screens

func _ready()-> void:
	screens.startGame.connect(_on_screens_start_game)
	
	game.playerDied.connect(_on_game_player_died)

func _on_screens_start_game()-> void:
	game.newGame()

func _on_game_player_died(score: int, hightScore: int)-> void:
	await get_tree().create_timer(0.75).timeout
	screens.gameOver(score, hightScore)
