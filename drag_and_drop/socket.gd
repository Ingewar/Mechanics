class_name Socket extends Control

signal object_placed(object: DraggableObject)
signal object_removed(object: DraggableObject)

@export var accepted_types: Array[DragDropObjectType] = []
@export var socket_color: Color = Color.GRAY
@export var highlight_color: Color = Color.GREEN
@export var reject_color: Color = Color.RED
@export var max_objects: int = 1

var current_object: DraggableObject = null
var background: ColorRect

func _ready():
	# Set up visual background
	background = ColorRect.new()
	background.name = "Background"
	background.color = socket_color
	background.anchors_preset = Control.PRESET_FULL_RECT
	background.position = Vector2.ZERO
	add_child(background)
	move_child(background, 0)
	
	# Enable mouse input for drop handling
	mouse_filter = Control.MOUSE_FILTER_PASS

# Check if we can accept the dragged data
func _can_drop_data(position: Vector2, data) -> bool:
	# Ensure data is a DraggableObject
	if not data is DraggableObject:
		_set_highlight(reject_color)
		return false
	
	var obj = data as DraggableObject
	
	# Check if we can accept this object
	if can_accept_object(obj):
		_set_highlight(highlight_color)
		return true
	else:
		_set_highlight(reject_color)
		return false

# Handle the actual drop
func _drop_data(position: Vector2, data):
	_reset_highlight()
	
	if not data is DraggableObject:
		return
	
	var obj = data as DraggableObject
	
	# Remove object from previous socket
	if obj.current_socket and obj.current_socket != self:
		obj.current_socket.remove_object()
	
	# Remove current object if replacing
	if current_object:
		remove_object()
	
	# Place the new object
	current_object = obj
	obj.place_in_socket(self)
	
	object_placed.emit(obj)

# Called when drag enters the socket area
func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		_reset_highlight()

func can_accept_object(obj: DraggableObject) -> bool:
	if not obj or not obj.object_type:
		return false
	
	# Check if socket is full
	if current_object != null and max_objects <= 1:
		return false
	
	# Check if object type is accepted
	if accepted_types.is_empty():
		return true  # Accept all types if none specified
	
	for accepted_type in accepted_types:
		if accepted_type and obj.object_type and accepted_type.type_id == obj.object_type.type_id:
			return true
	
	return false

func remove_object():
	if current_object:
		var obj = current_object
		current_object = null
		obj.remove_from_socket()
		object_removed.emit(obj)

func _set_highlight(color: Color):
	if background:
		background.color = color

func _reset_highlight():
	if background:
		background.color = socket_color
