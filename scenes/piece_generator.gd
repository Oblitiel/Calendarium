@tool
extends Node2D

var piece_prefab = preload("uid://ikddowsiq53w")

func _ready() -> void:
	#var diff_pos : Vector2 = ((finish_marker.global_position - star_marker.global_position)/ 15)
	
	for i in 16:
		var pience_instance : Piece = piece_prefab.instantiate()
		pience_instance.image = i
		#pience_instance.global_position = star_marker.global_position + diff_pos * i
		add_child(pience_instance)
		pience_instance.owner = get_tree().edited_scene_root
		pience_instance.name = "Piece%02d"%i
