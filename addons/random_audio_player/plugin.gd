@tool
extends EditorPlugin

func _enter_tree() -> void:
	add_custom_type("RandomAudioPlayer","Node",preload("res://addons/random_audio_player/random_audio_player.gd"),preload("res://addons/random_audio_player/icons/RandomAudioPlayer.svg"))

func _exit_tree() -> void:
	remove_custom_type("RandomAudioPlayer")
