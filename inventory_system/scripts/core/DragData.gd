class_name DragData
extends Resource

@export var source_slot: int = -1
@export var item: ItemResource
@export var quantity: int = 0
@export var source_inventory: InventoryManager

func _init(slot: int = -1, item_resource: ItemResource = null, qty: int = 0, inventory: InventoryManager = null):
	source_slot = slot
	item = item_resource
	quantity = qty
	source_inventory = inventory