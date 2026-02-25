@tool
extends Node
class_name RandomAudioPlayer

@export_group("Configuration")
@export var audio_player_reference : Node:
	set(value):
		change_audio_player_reference(value)
		audio_player_reference = value
		update_configuration_warnings()

@export var reset_on_play : bool = false

@export_group("Behavior")
@export var posible_sounds : Array[AudioStream] = []: 
	set(value):
		posible_sounds = value
		update_configuration_warnings()

@export_range(0.0,4.0,0.01,"or_greater") var pitch_deviation = 0.0
@export_range(0,80,0.001,"suffix: dB") var volume_deviation : float = 0.0

var base_volume : float = 0
var base_pitch : float = 1

var _audio_stream_player : Node:
	set(value):
		_unlink_audio_stream_player(_audio_stream_player)
		
		_audio_stream_player = value
		
		_link_audio_stream_player(_audio_stream_player)

func _ready() -> void:
	tree_entered.connect(update_configuration_warnings)
	change_audio_player_reference()
	randomize_next_play()

func randomize_next_play() -> void:
	if not _audio_stream_player:
		return
	
	if reset_on_play and _audio_stream_player:
		reset_base_values()
	
	if not posible_sounds.is_empty():
		_audio_stream_player.stream = posible_sounds.pick_random()
	
	var rand_pitch_deviation = randf_range(-pitch_deviation, pitch_deviation)
	_audio_stream_player.pitch_scale = maxf(base_pitch + rand_pitch_deviation,0.01)
	var rand_volume_deviation = randf_range(-volume_deviation, volume_deviation)
	_audio_stream_player.volume_db = clamp(base_volume + rand_volume_deviation,-80,24)

func change_audio_player_reference(candidate : Node = audio_player_reference) -> void:
	if candidate:
		assert(_is_audio_stream_player(candidate), "Selected node for 'audio_player_reference' must be some kind of AudioStreamPlayer")
		assert(candidate.is_ancestor_of(self), "Selected node for 'audio_player_reference' must be an ancestor of this RandomAudioPlayer")
	elif _is_audio_stream_player(get_parent()):
		candidate = get_parent()
	elif _is_audio_stream_player(owner):
		candidate = owner
	
	_audio_stream_player = candidate
	
	assert(_audio_stream_player != null,"RandomAudioPlayer node '%s' must be linked to an AudioStreamPlayer/AudioStreamPlayer2d/3D (export, parent, or owner)" % name)

func _link_audio_stream_player(audio_player : Node) -> void:
	if audio_player == null:
		return
	
	reset_base_values()
	
	audio_player.finished.connect(randomize_next_play)
	
	if base_pitch - pitch_deviation < 0.01:
		push_warning("Pitch deviation relative to the current pitch of the AudioStreamPlayer can be less than 0.01, in these cases the value will be clamped")
	
	if base_volume - volume_deviation < -80.0 or base_volume + volume_deviation > 24.0:
		push_warning("Volume deviation relative to the current volume of the AudioStreamPlayer can surpass the limits of the AudioStreamPLayer volume_db, in these cases the value will be clamped")

func _unlink_audio_stream_player(audio_player : Node) -> void:
	if audio_player == null:
		return
	
	audio_player.finished.disconnect(randomize_next_play)
	
	audio_player.volume_db = base_volume
	audio_player.pitch_scale = base_pitch

func reset_base_values():
	base_volume = _audio_stream_player.volume_db
	base_pitch = _audio_stream_player.pitch_scale

func _get_configuration_warnings() -> PackedStringArray:
	var warnings : PackedStringArray = PackedStringArray()
	
	# Verify if parent is an audio stream player
	if audio_player_reference != null and not audio_player_reference.is_ancestor_of(self):
		warnings.append("Audio Player Reference must be an ancestor of this node.")
	elif audio_player_reference == null and (not _is_audio_stream_player(get_parent()) or _is_audio_stream_player(owner)):
		warnings.append("This node doesn't have an audio stream player, so it can't play audio. \nConsider adding an AudioStreamPlayer, AudioStreamPlayer2D or AudioStreamPlayer3D as an ancestor in exports.")
	
	return warnings

func _is_audio_stream_player(node : Node) -> bool:
	return node is AudioStreamPlayer or node is AudioStreamPlayer2D or node is AudioStreamPlayer3D
