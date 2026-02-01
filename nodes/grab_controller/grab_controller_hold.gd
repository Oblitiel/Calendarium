extends GrabController

func _input(event: InputEvent) -> void:
	grab_logic(get_global_mouse_position(),event)

func grab_logic(grab_point : Vector2, event : InputEvent) -> void:
	if event.is_action_pressed("grab"):
		grab_item(grab_point)
	
	if event.is_action_released("grab") and grabbed_item:
		release_item()
