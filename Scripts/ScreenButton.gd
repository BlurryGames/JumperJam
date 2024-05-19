class_name ScreenButton extends TextureButton

signal clicked(button: TextureButton)

func _on_pressed()-> void:
	clicked.emit(self)
