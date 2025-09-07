class_name InventoryData extends Resource

@export var slots: Array[InventorySlot] = []
@export var max_slots: int = 20

func _init(slot_count: int = 20):
	max_slots = slot_count
	slots.resize(slot_count)
	for i in range(slot_count):
		slots[i] = InventorySlot.new()
