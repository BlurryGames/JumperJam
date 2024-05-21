class_name Player extends CharacterBody2D

signal died

@onready var animator: AnimationPlayer = $AnimationPlayer
@onready var collider: CollisionShape2D = $CollisionShape2D

var viewportSize: Vector2 = Vector2.ZERO

var speed: float = 300.0
var accelerometerSpeed: float = 130.0

var gravity: float = 15.0
var maxFallVelocity: float = 1000.0
var jumpVelocity: float = -800.0

var useAccelerometer: bool = false
var dead: bool = false

func _ready()-> void:
	viewportSize = get_viewport_rect().size
	
	var osName: String = OS.get_name()
	if osName == "Android" or osName == "iOS":
		useAccelerometer = true

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
	
	if not dead:
		if useAccelerometer:
			var mobileInput: Vector3 = Input.get_accelerometer()
			velocity.x = mobileInput.x * accelerometerSpeed
		else:
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

func _on_visible_on_screen_notifier_2d_screen_exited():
	die()

func jump()-> void:
	velocity.y = jumpVelocity
	SoundFXPtr.play("Jump")

func die()-> void:
	if not dead:
		dead = true
		collider.set_deferred("disabled", true)
		died.emit()
		SoundFXPtr.play("Fall")
