class_name SoundFX extends Node

@onready var soundPlayers: Array[Node] = get_children()

var sounds: Dictionary = {
	"Click": load("res://assets/sound/Click.wav"),
	"Fall": load("res://assets/sound/Fall.wav"),
	"Jump": load("res://assets/sound/Jump.wav")
}

func play(soundName: String)-> void:
	var soundToPlay: AudioStreamWAV = sounds[soundName]
	for s: AudioStreamPlayer in soundPlayers:
		if not s.is_playing():
			s.set_stream(soundToPlay)
			s.play()
			break
