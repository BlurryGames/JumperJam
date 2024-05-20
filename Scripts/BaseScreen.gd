class_name BaseScreen extends Control

func _ready()-> void:
	visible = false
	modulate.a = 0.0

func appear()-> Tween:
	visible = true
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1.0, 0.5)
	
	return tween

func disappear()-> Tween:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.5)
	
	return tween
