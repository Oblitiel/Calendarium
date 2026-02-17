extends Node2D

@export var start_marker : Marker2D
@export var finish_marker : Marker2D
@export_range(0,1,0.1,"or_greater","suffix:s") var positionig_time = 0.5

var finished : bool = false

func _on_mouse_click(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("grab"):
		var tween : Tween = create_tween()
		finished = not finished
		
		if finished:
			tween.tween_property(self,"global_position",finish_marker.global_position,positionig_time)
			check_win()
		else:
			tween.tween_property(self,"global_position",start_marker.global_position,positionig_time)

func check_win():
	pass
