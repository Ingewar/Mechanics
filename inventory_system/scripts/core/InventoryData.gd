class_name InventoryData
extends Resource

@export var max_slots: int = 20
@export var slots: Array[InventorySlot] = []

func _init():
	if slots.is_empty():
		_initialize_slots()

func _initialize_slots():
	slots.clear()
	for i in range(max_slots):
		slots.append(InventorySlot.new())