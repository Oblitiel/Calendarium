class_name Piece
extends GrabbableItem

@export_range(0,15,1) var image : int :
	set(value):
		image = value
		$CalendariumPieces.frame = image
		piece_composition = load("res://resources/piece_composition/Piece"+str(value)+".tres")

var piece_composition : PieceComposition
