class_name Piece
extends GrabbableItem

@export_range(0,15,1) var image : int :
	set(value):
		image = value
		$CalendariumPieces.frame = image

@export var piece_composition : PieceComposition

@onready var drop_sfxs: AudioStreamPlayer = $"Drop SFXs"
@onready var drag_sfxs: AudioStreamPlayer = $"Drag SFXs"

func _ready() -> void:
	super()
	$SubpieceBL.data=piece_composition.bottom_left
	$SubpieceTL.data=piece_composition.top_left
	$SubpieceTR.data=piece_composition.top_right
	$SubpieceBR.data=piece_composition.bottom_right

func grab(local_position : Vector2 = get_local_mouse_position()) -> void:
	super(local_position)
	drag_sfxs.play()

func release() -> void:
	super()
	drop_sfxs.play()
