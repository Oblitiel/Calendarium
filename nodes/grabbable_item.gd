class_name GrabbableItem
extends Area2D

static var index = 1

signal grabbed()
signal released()

var is_grabbed : bool
var grab_position : Vector2

func _ready() -> void:
	add_to_group("Grabbable")
	
	z_index = index
	index += 1

func _process(_delta: float) -> void:
	if is_grabbed:
		global_position = get_global_mouse_position() - grab_position

func grab(local_position : Vector2 = get_local_mouse_position()) -> void:
	arrange_z_index()
	
	is_grabbed = true
	grab_position = local_position
	
	grabbed.emit()

func release() -> void:
	is_grabbed = false
	
	released.emit()

func arrange_z_index() -> void:
	var items = get_tree().get_nodes_in_group("Grabbable")
	var higher_z_items = items.filter(
		func(i):
			return i.z_index > z_index
	)
	
	for item in higher_z_items:
		item.z_index -= 1
	
	z_index = items.size()
