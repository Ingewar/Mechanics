class_name InventorySlotUI
extends Control

signal slot_clicked(slot_index: int)
signal slot_hovered(slot_index: int)
signal slot_unhovered(slot_index: int)

@export var slot_data: InventorySlot
@export var slot_index: int = -1

@onready var background_panel: Panel = $BackgroundPanel
@onready var item_icon: TextureRect = $ItemIcon
@onready var quantity_label: Label = $QuantityLabel

var inventory_manager: InventoryManager

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	gui_input.connect(_on_gui_input)
	update_display()

func setup(slot_data_ref: InventorySlot, index: int, manager: InventoryManager):
	slot_data = slot_data_ref
	slot_index = index
	inventory_manager = manager
	update_display()

func update_display():
	if not slot_data or slot_data.is_empty():
		item_icon.texture = null
		quantity_label.text = ""
		quantity_label.visible = false
	else:
		item_icon.texture = slot_data.item.icon
		if slot_data.quantity > 1:
			quantity_label.text = str(slot_data.quantity)
			quantity_label.visible = true
		else:
			quantity_label.visible = false

func _can_drop_data(position: Vector2, data: Variant) -> bool:
	if not data is DragData:
		return false
	
	var drag_data = data as DragData
	if not drag_data.item:
		return false
	
	# Can't drop on the same slot
	if drag_data.source_slot == slot_index and drag_data.source_inventory == inventory_manager:
		return false
	
	# If slot is empty, can always drop
	if slot_data.is_empty():
		return true
	
	# If items can stack
	if inventory_manager.can_stack_items(slot_data.item, drag_data.item):
		return slot_data.quantity < slot_data.item.stack_size
	
	# Otherwise can swap
	return true

func _drop_data(position: Vector2, data: Variant) -> void:
	if not data is DragData:
		return
	
	var drag_data = data as DragData
	
	# Handle drop from same inventory
	if drag_data.source_inventory == inventory_manager:
		inventory_manager.move_item(drag_data.source_slot, slot_index)
	else:
		# Handle cross-inventory transfer (if needed in future)
		pass

func _get_drag_data(position: Vector2) -> Variant:
	if slot_data.is_empty():
		return null
	
	var drag_data = DragData.new(slot_index, slot_data.item, slot_data.quantity, inventory_manager)
	
	# Create drag preview
	var preview = Control.new()
	var preview_icon = TextureRect.new()
	preview_icon.texture = slot_data.item.icon
	preview_icon.size = Vector2(32, 32)
	preview.add_child(preview_icon)
	set_drag_preview(preview)
	
	return drag_data

func _on_mouse_entered():
	slot_hovered.emit(slot_index)

func _on_mouse_exited():
	slot_unhovered.emit(slot_index)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		slot_clicked.emit(slot_index)