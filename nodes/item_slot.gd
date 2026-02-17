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
	
	posible_targets = posible_targets.filter(func(t):return t is GrabbableItem and not t.is_grabbed)
	
	if posible_targets.size() < 1:
		return null
	
	var nearest_target = posible_targets[0]
	for posi_target in posible_targets:
		if abs(posi_target.global_position - global_position) < abs(nearest_target.global_position - global_position):
			nearest_target = posi_target
	return nearest_target

func position_item(item : GrabbableItem) -> void:
	var tween = item.create_tween()
	tween.tween_property(item,"global_position",global_position,positionig_time)
	await tween.finished
	tween.kill()
