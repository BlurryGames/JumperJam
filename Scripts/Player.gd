class_name Player extends CharacterBody2D

var speed: float = 300.0

func _physics_process(delta: float)-> void:
	var direction: float = Input.get_axis("MoveLeft", "MoveRight")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
	
	move_and_slide()
