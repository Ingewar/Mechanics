class_name DraggableObject extends Control

signal drag_started(object: DraggableObject)
signal drag_ended(object: DraggableObject, success: bool)

@export var object_type: DragDropObjectType
@export var drag_preview_scale: float = 1.1

var original_position: Vector2
var original_parent: Node
var current_socket: Socket = null
var drag_success: bool = false

func _ready():
	# Store original position and parent
	original_position = global_position
	original_parent = get_parent()
	
	# Apply object type styling if available
	if object_type:
		modulate = object_type.color
	
	# Enable mouse input for drag and drop
	mouse_filter = Control.MOUSE_FILTER_PASS
	
	# Enable drag detection
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

# Called when drag operation starts
func _get_drag_data(position: Vector2):
	print_debug("get_drag")
	# Create drag preview
	var preview = _create_drag_preview()
	set_drag_preview(preview)
	
	# Notify about drag start
	drag_started.emit(self)
	drag_success = false
	
	# Return the data being dragged (this object)
	return self

# Create visual preview for dragging
func _create_drag_preview() -> Control:
	var preview = Control.new()
	
	# Copy the visual appearance
	var bg = ColorRect.new()
	bg.size = size
	bg.color = object_type.color if object_type else Color.WHITE
	bg.modulate = Color(1, 1, 1, 0.8)  # Semi-transparent
	preview.add_child(bg)
	
	# Copy label if it exists
	var label = get_node_or_null("Background/Label")
	if label:
		var preview_label = Label.new()
		preview_label.text = label.text
		preview_label.size = size
		preview_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		preview_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		preview.add_child(preview_label)
	
	# Scale up the preview
	preview.scale = Vector2.ONE * drag_preview_scale
	
	return preview

# Called when drag operation ends (whether successful or not)
func _notification(what):
	if what == NOTIFICATION_DRAG_END:
		drag_ended.emit(self, drag_success)
		
		# If drag failed, return to original position
		if not drag_success:
			_return_to_original_position()

func _return_to_original_position():
	# Remove from current socket if any
	if current_socket:
		current_socket.remove_object()
	
	# Return to original parent and position
	if get_parent() != original_parent:
		reparent(original_parent)
	
	# Animate back to original position
	var tween = create_tween()
	tween.tween_property(self, "global_position", original_position, 0.3)
	tween.tween_property(self, "modulate", object_type.color if object_type else Color.WHITE, 0.1)

func place_in_socket(socket: Socket):
	current_socket = socket
	drag_success = true
	
	# Move to socket
	reparent(socket)
	position = Vector2.ZERO

func remove_from_socket():
	if current_socket:
		current_socket = null

func _on_mouse_entered():
	if not Input.is_action_pressed("ui_select"):  # Not dragging
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color.WHITE * 1.2, 0.1)

func _on_mouse_exited():
	if not Input.is_action_pressed("ui_select"):  # Not dragging
		var color = object_type.color if object_type else Color.WHITE
		var tween = create_tween()
		tween.tween_property(self, "modulate", color, 0.1)
