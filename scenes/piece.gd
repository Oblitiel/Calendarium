class_name Piece
extends GrabbableItem

@export_range(0,15,1) var image : int :
	set(value):
		image = value
		$CalendariumPieces.frame = image
