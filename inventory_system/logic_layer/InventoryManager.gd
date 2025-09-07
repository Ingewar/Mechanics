class_name InventoryManager extends Node

signal item_added(item: ItemResource, quantity: int)
signal item_removed(item: ItemResource, quantity: int)
signal slot_changed(slot_index: int)

var inventory_data: InventoryData

func add_item(item:ItemResource, quantity:int) -> bool:
	item_added.emit(item, quantity)
	return true
	
func remove_item(item:ItemResource, quantity:int) -> bool:
	item_removed.emit(item, quantity)
	return true
	
func move_item(from_slot:int, to_slot:int) -> bool:
	slot_changed.emit(to_slot)
	return true
	
func can_stack_items(item1: ItemResource, item2: ItemResource) -> bool:
	return true
