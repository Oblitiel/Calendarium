@abstract
class_name GrabController
extends Node2D

var grabbed_item : GrabbableItem = null
@export_flags_2d_physics var grabbable_items_collisions : int = 1

@abstract func grab_logic(grab_point : Vector2, event : InputEvent) -> void

func grab_item(grab_point : Vector2):
	grabbed_item = get_grabbable_item_in_point(grab_point)
	if grabbed_item:
		grabbed_item.grab()

func release_item():
	grabbed_item.release()
	grabbed_item = null

func get_grabbable_item_in_point(point : Vector2) -> GrabbableItem:
	var parameters : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()
	
	parameters.collide_with_areas = true
	parameters.collide_with_bodies = false
	parameters.collision_mask = grabbable_items_collisions
	parameters.position = point
	
	var clicked_objects = get_world_2d().direct_space_state.intersect_point(parameters)
	
	if clicked_objects.size() < 1 :
		return null
	
	var colliders : Array = clicked_objects.map(
		func(obj):
			return obj.collider
	)
	
	colliders.sort_custom(_sort_z_idex)
	
	return colliders[0]

func _sort_z_idex(a:Node2D, b:Node2D) -> bool:
	return a.z_index > b.z_index
