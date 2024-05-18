class_name GameCamera extends Camera2D

var player: Player = null

func _ready()-> void:
	global_position.x = get_viewport_rect().size.x * 0.5

func _physics_process(_delta: float)-> void:
	if player:
		global_position.y = player.global_position.y

func setupCamera(_player: Player)-> void:
	if _player:
		player = _player
