class_name GameCamera extends Camera2D

@onready var destroyer: Area2D = $Destroyer
@onready var collider: CollisionShape2D = $Destroyer/CollisionShape2D

var player: Player = null

var viewportSize: Vector2 = Vector2.ZERO

func _ready()-> void:
	viewportSize = get_viewport_rect().size
	global_position.x = viewportSize.x * 0.5
	
	limit_bottom = int(viewportSize.y)
	limit_left = 0
	limit_right = int(viewportSize.x)
	
	destroyer.position.y = viewportSize.y
	
	var rectangleShape: RectangleShape2D = RectangleShape2D.new()
	var rectangleShapeSize: Vector2 = Vector2(viewportSize.x, 200.0)
	rectangleShape.set_size(rectangleShapeSize)
	collider.shape = rectangleShape

func _process(_delta: float)-> void:
	if player:
		var limitDistance: float = 420.0
		if limit_bottom > player.global_position.y + limitDistance:
			limit_bottom = int(player.global_position.y + limitDistance)
	
	var overlappingAreas = destroyer.get_overlapping_areas()
	if overlappingAreas.size() > 0:
		for a: Platform in overlappingAreas:
			if a is Platform:
				a.queue_free()

func _physics_process(_delta: float)-> void:
	if player:
		global_position.y = player.global_position.y

func setupCamera(_player: Player)-> void:
	if _player:
		player = _player
