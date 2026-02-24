@tool
class_name RandomAudioPlayer
extends Node

@export_group("Configuration")
@export var audio_player_reference : Node:
	set(value):
		audio_player_reference = value
		update_configuration_warnings()

@export_group("Behavior")
@export var posible_sounds : Array[AudioStream] = []: 
	set(value):
		posible_sounds = value
		update_configuration_warnings()

@export_subgroup("Random Pitch")
@export_range(0.01,4,0.01,"or_greater") var min_pitch_scale_mod : float = 1.0:
	set(value):
		min_pitch_scale_mod = value
		if min_pitch_scale_mod > max_pitch_scale_mod:
			max_pitch_scale_mod = min_pitch_scale_mod
		update_configuration_warnings()

@export_range(0.01,4,0.01,"or_greater") var max_pitch_scale_mod : float = 1.0:
	set(value):
		max_pitch_scale_mod = value
		if max_pitch_scale_mod < min_pitch_scale_mod:
			min_pitch_scale_mod = max_pitch_scale_mod
		update_configuration_warnings()

@export_subgroup("Random Volume")
@export_range(-80,24,0.001,"suffix: dB") var min_volume_mod : float = 0.0:
	set(value):
		min_volume_mod = value
		if min_volume_mod > max_volume_mod:
			max_volume_mod = min_volume_mod
		update_configuration_warnings()

@export_range(-80,24,0.001,"suffix: dB") var max_volume_mod : float = 0.0:
	set(value):
		max_volume_mod = value
		if max_volume_mod < min_volume_mod:
			min_volume_mod = max_volume_mod
		update_configuration_warnings()

var _audio_stream_player : Node

func _ready() -> void:
	tree_entered.connect(update_configuration_warnings)
	
	var candidate = null
	
	if audio_player_reference != null:
		assert(_is_audio_stream_player(audio_player_reference), "Selected node for 'audio_player_reference' must be some kind of AudioStreamPlayer")
		assert(audio_player_reference.is_ancestor_of(self), "Selected node for 'audio_player_reference' must be an ancestor of this RandomAudioPlayer")
		candidate = audio_player_reference
	elif _is_audio_stream_player(get_parent()):
		candidate = get_parent()
	elif _is_audio_stream_player(owner):
		candidate = owner
	
	_audio_stream_player = candidate
	
	assert(_audio_stream_player != null,"RandomAudioPlayer node '%s' must be linked to an AudioStreamPlayer/AudioStreamPlayer2d/3D (export, parent, or owner)" % name)
	
	_audio_stream_player.finished.connect(_randomize_next_play)
	_randomize_next_play()

func _randomize_next_play():
	if not posible_sounds.is_empty():
		_audio_stream_player.stream = posible_sounds.pick_random()
	_audio_stream_player.pitch_scale = randf_range(min_pitch_scale_mod,max_pitch_scale_mod)
	_audio_stream_player.volume_db = randf_range(min_volume_mod,max_volume_mod)

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = PackedStringArray()
	
	# Verify if parent is an audio stream player
	if audio_player_reference != null and not audio_player_reference.is_ancestor_of(self):
		warnings.append("Audio Player Reference must be an ancestor of this node.")
	elif audio_player_reference == null and (not _is_audio_stream_player(get_parent()) or _is_audio_stream_player(owner)):
		warnings.append("This node doesn't have an audio stream player, so it can't play audio. \nConsider adding an AudioStreamPlayer, AudioStreamPlayer2D or AudioStreamPlayer3D as an ancestor in exports.")
	if (
		not posible_sounds and
		min_pitch_scale_mod == 1.0 and
		max_pitch_scale_mod == 1.0 and
		min_volume_mod == 0.0 and
		max_volume_mod == 0.0
	):
		warnings.append("This node is not going to randomize any of the sound attributes. \nConsider changing its export attributes.")
	
	return warnings

func _is_audio_stream_player(node : Node) -> bool:
	return node is AudioStreamPlayer or node is AudioStreamPlayer2D or node is AudioStreamPlayer3D
