class_name InventoryUI extends Control

@onready var grid_container: GridContainer = $GridContainer
@export var slot_scene: PackedScene = preload("res://inventory_system/scenes/ui/InventorySlotUI.tscn")

var inventory_manager: InventoryManager
var slot_ui_instances: Array[InventorySlotUI] = []

func setup(manager: InventoryManager):
	inventory_manager = manager
	inventory_manager.slot_changed.connect(_on_slot_changed)
	
	if is_inside_tree():
		_create_slot_ui_elements()
	else:
		await ready
		_create_slot_ui_elements()

func _create_slot_ui_elements():
	if not inventory_manager or not inventory_manager.inventory_data:
		return
	
	# Clear existing slots
	for child in grid_container.get_children():
		child.queue_free()
	slot_ui_instances.clear()
	
	# Create slot UI elements
	for i in range(inventory_manager.inventory_data.max_slots):
		var slot_ui = slot_scene.instantiate() as InventorySlotUI
		grid_container.add_child(slot_ui)
		
		slot_ui.setup(inventory_manager.inventory_data.slots[i], i, inventory_manager)
		slot_ui_instances.append(slot_ui)
		
		# Connect slot signals
		slot_ui.slot_clicked.connect(_on_slot_clicked)
		slot_ui.slot_hovered.connect(_on_slot_hovered)
		slot_ui.slot_unhovered.connect(_on_slot_unhovered)

func _on_slot_changed(slot_index: int):
	if slot_index >= 0 and slot_index < slot_ui_instances.size():
		slot_ui_instances[slot_index].update_display()

func _on_slot_clicked(slot_index: int):
	pass

func _on_slot_hovered(slot_index: int):
	pass

func _on_slot_unhovered(slot_index: int):
	pass