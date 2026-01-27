class_name GrabbableItem
extends Area2D

var is_grabbed : bool
var click_position : Vector2

func _ready() -> void:
	#Connect to the grab controller
	
	
	input_event.connect(_on_input_event)

func _process(_delta: float) -> void:
	if is_grabbed:
		global_position = get_global_mouse_position() - click_position

func _on_input_event(_viewport: Node, event: InputEvent, _shape_idx: int):
	if event.is_action_pressed("grab"):
		is_grabbed = true
		click_position = get_local_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_released("grab"):
		is_grabbed = false
