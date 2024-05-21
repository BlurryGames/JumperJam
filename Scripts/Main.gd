class_name Main extends Node

@onready var game: Game = $Game
@onready var screens: Screens = $Screens

var gameInProgress: bool = false

func _ready()-> void:
	DisplayServer.window_set_window_event_callback(_on_window_event)
	
	screens.startGame.connect(_on_screens_start_game)
	screens.deleteLevel.connect(_on_screen_delete_level)
	
	game.playerDied.connect(_on_game_player_died)
	game.pauseGame.connect(_on_game_pause_game)

func _on_game_player_died(score: int, hightScore: int)-> void:
	gameInProgress = false
	await get_tree().create_timer(0.75).timeout
	screens.gameOver(score, hightScore)

func _on_window_event(event: DisplayServer.WindowEvent)-> void:
	match event:
		DisplayServer.WINDOW_EVENT_FOCUS_IN:
			UtilityPtr.addLogMessage("Focus in")
		DisplayServer.WINDOW_EVENT_FOCUS_OUT:
			if gameInProgress and not get_tree().is_paused():
				_on_game_pause_game()
		DisplayServer.WINDOW_EVENT_CLOSE_REQUEST:
			get_tree().quit()

func _on_screens_start_game()-> void:
	gameInProgress = true
	game.newGame()

func _on_screen_delete_level()-> void:
	gameInProgress = false
	game.resetGame()

func _on_game_pause_game()-> void:
	get_tree().set_pause(true)
	screens.pauseGame()
