class_name InventoryManager
extends RefCounted

signal item_added(item: ItemResource, quantity: int)
signal item_removed(item: ItemResource, quantity: int)
signal slot_changed(slot_index: int)

var inventory_data: InventoryData

func _init(data: InventoryData = null):
	if data:
		inventory_data = data
	else:
		inventory_data = InventoryData.new()

func add_item(item: ItemResource, quantity: int = 1) -> bool:
	if not item or quantity <= 0:
		return false
	
	var remaining_quantity = quantity
	
	# First try to stack with existing items
	for i in range(inventory_data.slots.size()):
		var slot = inventory_data.slots[i]
		if not slot.is_empty() and can_stack_items(slot.item, item):
			var can_add = min(remaining_quantity, item.stack_size - slot.quantity)
			if can_add > 0:
				slot.quantity += can_add
				remaining_quantity -= can_add
				slot_changed.emit(i)
				
				if remaining_quantity <= 0:
					item_added.emit(item, quantity)
					return true
	
	# Then try to find empty slots
	for i in range(inventory_data.slots.size()):
		var slot = inventory_data.slots[i]
		if slot.is_empty():
			var can_add = min(remaining_quantity, item.stack_size)
			slot.item = item
			slot.quantity = can_add
			remaining_quantity -= can_add
			slot_changed.emit(i)
			
			if remaining_quantity <= 0:
				item_added.emit(item, quantity)
				return true
	
	# Partial success - some items were added
	if remaining_quantity < quantity:
		item_added.emit(item, quantity - remaining_quantity)
		return false
	
	return false

func remove_item(item: ItemResource, quantity: int = 1) -> int:
	if not item or quantity <= 0:
		return 0
	
	var removed_quantity = 0
	
	for i in range(inventory_data.slots.size()):
		var slot = inventory_data.slots[i]
		if not slot.is_empty() and slot.item == item:
			var can_remove = min(quantity - removed_quantity, slot.quantity)
			slot.quantity -= can_remove
			removed_quantity += can_remove
			
			if slot.quantity <= 0:
				slot.item = null
				slot.quantity = 0
			
			slot_changed.emit(i)
			
			if removed_quantity >= quantity:
				break
	
	if removed_quantity > 0:
		item_removed.emit(item, removed_quantity)
	
	return removed_quantity

func move_item(from_slot: int, to_slot: int) -> bool:
	if from_slot < 0 or from_slot >= inventory_data.slots.size():
		return false
	if to_slot < 0 or to_slot >= inventory_data.slots.size():
		return false
	if from_slot == to_slot:
		return false
	
	var source_slot = inventory_data.slots[from_slot]
	var target_slot = inventory_data.slots[to_slot]
	
	if source_slot.is_empty():
		return false
	
	# If target is empty, just move
	if target_slot.is_empty():
		target_slot.item = source_slot.item
		target_slot.quantity = source_slot.quantity
		source_slot.item = null
		source_slot.quantity = 0
		slot_changed.emit(from_slot)
		slot_changed.emit(to_slot)
		return true
	
	# If items can stack
	if can_stack_items(source_slot.item, target_slot.item):
		var can_move = min(source_slot.quantity, target_slot.item.stack_size - target_slot.quantity)
		if can_move > 0:
			target_slot.quantity += can_move
			source_slot.quantity -= can_move
			
			if source_slot.quantity <= 0:
				source_slot.item = null
				source_slot.quantity = 0
			
			slot_changed.emit(from_slot)
			slot_changed.emit(to_slot)
			return true
	else:
		# Swap items
		var temp_item = source_slot.item
		var temp_quantity = source_slot.quantity
		
		source_slot.item = target_slot.item
		source_slot.quantity = target_slot.quantity
		target_slot.item = temp_item
		target_slot.quantity = temp_quantity
		
		slot_changed.emit(from_slot)
		slot_changed.emit(to_slot)
		return true
	
	return false

func can_stack_items(item1: ItemResource, item2: ItemResource) -> bool:
	if not item1 or not item2:
		return false
	return item1 == item2 and item1.stack_size > 1