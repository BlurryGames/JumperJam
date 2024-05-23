class_name Screens extends CanvasLayer

signal startGame
signal deleteLevel
signal purchaseSkin
signal resetPurchases

@onready var console: Control = $Debug/ConsoleLog

@onready var titleScreen: BaseScreen = $TitleScreen
@onready var pauseScreen: BaseScreen = $PauseScreen
@onready var gameOverScreen: BaseScreen = $GameOverScreen
@onready var shopScreen: BaseScreen = $ShopScreen

@onready var gameOverScoreLabel: Label = $GameOverScreen/BalckBackground/Box/ScoreLabel
@onready var gameOverHightScoreLabel: Label = $GameOverScreen/BalckBackground/Box/HightScoreLabel

var currentScreen: BaseScreen = null

func _ready()-> void:
	console.visible = false
	
	registerButtons()
	changeScreen(titleScreen)

func _on_toggle_console_pressed()-> void:
	console.visible = not console.visible

func _on_button_pressed(button: TextureButton)-> void:
	SoundFXPtr.play("Click")
	match button.name:
		"TitlePlay":
			changeScreen(null)
			await get_tree().create_timer(0.5).timeout
			startGame.emit()
		"TitleShop":
			changeScreen(shopScreen)
		"PauseRetry":
			changeScreen(null)
			await get_tree().create_timer(0.75).timeout
			get_tree().set_pause(false)
			startGame.emit()
		"PauseBack":
			changeScreen(titleScreen)
			get_tree().set_pause(false)
			deleteLevel.emit()
		"PauseClose":
			changeScreen(null)
			await get_tree().create_timer(0.75).timeout
			get_tree().set_pause(false)
		"GameOverRetry":
			changeScreen(null)
			await get_tree().create_timer(0.5).timeout
			startGame.emit()
		"GameOverBack":
			changeScreen(titleScreen)
			deleteLevel.emit()
		"ShopBack":
			changeScreen(titleScreen)
		"ShopPurchaseSkin":
			purchaseSkin.emit()
		"ShopResetPurchases":
			resetPurchases.emit()

func changeScreen(newScreen: BaseScreen)-> void:
	if currentScreen:
		var disappearTwin: Tween = currentScreen.disappear()
		await disappearTwin.finished
		currentScreen.visible = false
	
	currentScreen = newScreen
	if currentScreen:
		var appearTween: Tween = currentScreen.appear()
		await appearTween.finished
		get_tree().call_group("Buttons", "set_disabled", false)

func gameOver(score: int, hightScore: int)-> void:
	gameOverScoreLabel.text = "Score: " + str(score)
	gameOverHightScoreLabel.text = "Best: " + str(hightScore)
	changeScreen(gameOverScreen)

func pauseGame()-> void:
	changeScreen(pauseScreen)

func registerButtons()-> void:
	var buttons: Array[Node] = get_tree().get_nodes_in_group("Buttons")
	if buttons.size() > 0:
		for b: Node in buttons:
			if b is ScreenButton:
				b.clicked.connect(_on_button_pressed)
