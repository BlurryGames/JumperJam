class_name GameCamera extends Camera2D

@onready var destroyer: Area2D = $Destroyer
@onready var collider: CollisionShape2D = $Destroyer/CollisionShape2D

var player: Player = null

var viewportSize: Vector2 = Vector2.ZERO

func _ready()-> void:
	viewportSize = get_viewport_rect().size
	global_position.x = viewportSize.x * 0.5
	
	limit_bottom = viewportSize.y
	limit_left = 0.0
	limit_right = viewportSize.x
	
	destroyer.position.y = viewportSize.y * 0.5
	
	var rectangleShape: RectangleShape2D = RectangleShape2D.new()
	var rectangleShapeSize: Vector2 = Vector2(viewportSize.x, 200.0)
	rectangleShape.set_size(rectangleShapeSize)
	destroyer.shape = rectangleShape

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
