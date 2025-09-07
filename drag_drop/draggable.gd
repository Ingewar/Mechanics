extends Control

func _ready() -> void:
	for child in get_children():
		if child is Control:
			child.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _get_drag_data(at_position: Vector2) -> Variant:
	print_debug("Getting drag data")
	return self
