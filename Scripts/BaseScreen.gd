class_name BaseScreen extends Control

func _ready()-> void:
	visible = false
	modulate.a = 0.0
	
	get_tree().call_group("Buttons", "set_disabled", true)

func appear()-> Tween:
	visible = true
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 1.0)
	
	return tween

func disappear()-> Tween:
	get_tree().call_group("Buttons", "set_disabled", true)
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	
	return tween
