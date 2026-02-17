extends Node2D

@export var star_marker : Marker2D
@export var finish_marker : Marker2D

var piece_prefab = preload("uid://ikddowsiq53w")

func _ready() -> void:
	var diff_pos : Vector2 = ((finish_marker.global_position - star_marker.global_position)/ 15)
	
	for i in 16:
		var pience_instance : Piece = piece_prefab.instantiate()
		add_child(pience_instance)
		pience_instance.image = i
		pience_instance.global_position = star_marker.global_position + diff_pos * i
