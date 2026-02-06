class_name ItemSlot
extends Area2D

var item_in_spot : GrabbableItem

func _ready() -> void:
	connect("area_exited",_on_area_exit)

func _physics_process(_delta: float) -> void:
	pass
	
	if has_overlapping_areas() and (not item_in_spot ) and not get_overlapping_areas()[0].is_grabbed:
		item_in_spot = get_overlapping_areas()[0]
		var item_tween = item_in_spot.create_tween()
		item_tween.tween_property(item_in_spot, "global_position", global_position, 0.5)
		await item_tween.finished
		item_tween.kill()

func _on_area_exit(area : Area2D):
	if area == item_in_spot:
		item_in_spot = null
