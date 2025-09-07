extends Node

var items_by_id: Dictionary = {}

func _ready():
	_load_items()

func _load_items():
	# This will be populated with item resources when they're created
	# For now, it's empty but ready to register items
	pass

func register_item(item: ItemResource):
	if item and item.id != "":
		items_by_id[item.id] = item

func get_item_by_id(id: String) -> ItemResource:
	return items_by_id.get(id, null)

func has_item(id: String) -> bool:
	return items_by_id.has(id)

func get_all_items() -> Array[ItemResource]:
	var items: Array[ItemResource] = []
	for item in items_by_id.values():
		items.append(item)
	return items

func get_items_by_type(item_type: ItemResource.ItemType) -> Array[ItemResource]:
	var items: Array[ItemResource] = []
	for item in items_by_id.values():
		if item.item_type == item_type:
			items.append(item)
	return items