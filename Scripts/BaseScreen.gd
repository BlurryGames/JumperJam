class_name BaseScreen extends Control

func _ready()-> void:
	visible = false

func appear()-> void:
	visible = true

func disappear()-> void:
	visible = false
