class_name Piece
extends GrabbableItem

@export_range(0,15,1) var image : int :
	set(value):
		image = value
		$CalendariumPieces.frame = image

@export var piece_composition : PieceComposition

func _ready() -> void:
	super()
	$SubpieceBL.data=piece_composition.bottom_left
	$SubpieceTL.data=piece_composition.top_left
	$SubpieceTR.data=piece_composition.top_right
	$SubpieceBR.data=piece_composition.bottom_right
