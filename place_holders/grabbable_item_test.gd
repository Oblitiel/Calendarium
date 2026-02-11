extends GrabbableItem

func _process(_delta: float) -> void:
	super(_delta)
	$Label.text = str(z_index)
