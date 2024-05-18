class_name Player extends CharacterBody2D

@onready var animator: AnimationPlayer = $AnimationPlayer

var viewportSize: Vector2 = Vector2.ZERO

var speed: float = 300.0
var gravity: float = 15.0
var maxFallVelocity: float = 1000.0
var jumpVelocity: float = -800.0

func _ready()-> void:
	viewportSize = get_viewport_rect().size

func _process(_delta: float)-> void:
	if velocity.y > 0.0:
		if animator.current_animation != "Fall":
			animator.play("Fall")
	elif velocity.y < 0.0:
		if animator.current_animation != "Jump":
			animator.play("Jump")

func _physics_process(_delta: float)-> void:
	velocity.y += gravity
	if velocity.y > maxFallVelocity:
		velocity.y = maxFallVelocity
	
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

func jump()-> void:
	velocity.y = jumpVelocity
