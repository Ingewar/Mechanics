extends Control

@onready var inventory_ui: InventoryUI = $VBoxContainer/InventoryUI

var demo_inventory: InventoryManager

func _ready():
	_setup_demo_inventory()
	_create_sample_items()
	_setup_ui()

func _setup_demo_inventory():
	var inventory_data = InventoryData.new()
	inventory_data.max_slots = 20
	demo_inventory = InventoryManager.new(inventory_data)

func _create_sample_items():
	# Create health potion
	var health_potion = ItemResource.new()
	health_potion.id = "health_potion"
	health_potion.name = "Health Potion"
	health_potion.description = "Restores 50 HP"
	health_potion.stack_size = 10
	health_potion.item_type = ItemResource.ItemType.CONSUMABLE
	
	# Create iron sword
	var iron_sword = ItemResource.new()
	iron_sword.id = "iron_sword"
	iron_sword.name = "Iron Sword"
	iron_sword.description = "A sturdy iron sword. Attack power: 15"
	iron_sword.stack_size = 1
	iron_sword.item_type = ItemResource.ItemType.EQUIPMENT
	
	# Create oak wood
	var oak_wood = ItemResource.new()
	oak_wood.id = "oak_wood"
	oak_wood.name = "Oak Wood"
	oak_wood.description = "Common crafting material"
	oak_wood.stack_size = 64
	oak_wood.item_type = ItemResource.ItemType.MATERIAL
	
	# Add items to inventory
	demo_inventory.add_item(health_potion, 5)
	demo_inventory.add_item(iron_sword, 1)
	demo_inventory.add_item(oak_wood, 15)

func _setup_ui():
	inventory_ui.setup(demo_inventory)

func _on_add_health_potion_pressed():
	var health_potion = ItemResource.new()
	health_potion.id = "health_potion"
	health_potion.name = "Health Potion"
	health_potion.description = "Restores 50 HP"
	health_potion.stack_size = 10
	health_potion.item_type = ItemResource.ItemType.CONSUMABLE
	demo_inventory.add_item(health_potion, 1)

func _on_clear_inventory_pressed():
	for i in range(demo_inventory.inventory_data.max_slots):
		var slot = demo_inventory.inventory_data.slots[i]
		if not slot.is_empty():
			slot.item = null
			slot.quantity = 0
			demo_inventory.slot_changed.emit(i)
