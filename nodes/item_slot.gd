class_name ItemSlot
extends Area2D

var item_placed : GrabbableItem


func _physics_process(_delta: float) -> void:
	var items_in_spot : Array = get_overlapping_areas()
	if (
		items_in_spot.size() > 0
		and not item_placed
		and not items_in_spot[0].is_grabbed
	):
		item_placed = items_in_spot[0]
		item_placed.global_position = global_position
	else:
		item_placed = null
