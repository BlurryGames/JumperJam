class_name Player extends CharacterBody2D

var viewportSize: Vector2 = Vector2.ZERO

var speed: float = 300.0

func _ready()-> void:
	viewportSize = get_viewport_rect().size

func _physics_process(delta: float)-> void:
	var direction: float = Input.get_axis("MoveLeft", "MoveRight")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
	
	move_and_slide()
	
	var margin: float = 20.0
	if global_position.x > viewportSize.x + margin:
		global_position.x = -margin
	elif global_position.x < -margin:
		global_position.x = viewportSize.x + margin
