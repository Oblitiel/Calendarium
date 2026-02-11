class_name ItemSlot
extends Area2D

@export_range(0,1,0.1,"or_greater","suffix:s") var positionig_time = 0.2

var target : GrabbableItem

func _ready() -> void:
	area_entered.connect(_connect_item)
	area_exited.connect(_disconnect_item)

func _connect_item(area : Area2D):
	if area is GrabbableItem:
		area.grabbed.connect(_update_target_position)
		area.released.connect(_update_target_position)

func _disconnect_item(area : Area2D):
	if area is GrabbableItem:
		area.grabbed.disconnect(_update_target_position)
		area.released.disconnect(_update_target_position)

func _update_target_position():
	target = filter_target(get_overlapping_areas())
	if target:
		position_item(target)

func filter_target(posible_targets : Array) -> GrabbableItem:
	if target and not target.is_grabbed:
		return target
	for posible_target in posible_targets:
		if posible_target is GrabbableItem and not posible_target.is_grabbed:
			return posible_target
	return null

func position_item(item : GrabbableItem) -> void:
	var tween = item.create_tween()
	tween.tween_property(item,"global_position",global_position,positionig_time)
	await tween.finished
	tween.kill()
