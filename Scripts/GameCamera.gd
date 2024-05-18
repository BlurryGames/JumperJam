class_name GameCamera extends Camera2D

var player: Player = null

var viewportSize: Vector2 = Vector2.ZERO

func _ready()-> void:
	viewportSize = get_viewport_rect().size
	global_position.x = viewportSize.x * 0.5
	
	limit_bottom = viewportSize.y
	limit_left = 0.0
	limit_right = viewportSize.x

func _process(_delta: float)-> void:
	if player:
		var limitDistance: float = 420.0
		if limit_bottom > player.global_position.y + limitDistance:
			limit_bottom = player.global_position.y + limitDistance

func _physics_process(_delta: float)-> void:
	if player:
		global_position.y = player.global_position.y

func setupCamera(_player: Player)-> void:
	if _player:
		player = _player
