extends GrabController

func _input(event: InputEvent) -> void:
	grab_logic(get_global_mouse_position(),event)

func grab_logic(grab_point : Vector2, event : InputEvent) -> void:
	if event.is_action_pressed("grab"):
		if grabbed_item:
			release_item()
		else:
			grab_item(grab_point)
