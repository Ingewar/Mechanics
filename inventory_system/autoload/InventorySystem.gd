extends Node

var player_inventory: InventoryManager

func _ready():
	_initialize_player_inventory()

func _initialize_player_inventory():
	var inventory_data = InventoryData.new()
	inventory_data.max_slots = 20
	player_inventory = InventoryManager.new(inventory_data)