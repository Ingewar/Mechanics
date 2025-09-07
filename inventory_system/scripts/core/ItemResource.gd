class_name ItemResource
extends Resource

enum ItemType {
	CONSUMABLE,
	EQUIPMENT,
	MATERIAL,
	QUEST,
	MISC
}

@export var id: String = ""
@export var name: String = ""
@export var description: String = ""
@export var icon: Texture2D
@export var stack_size: int = 1
@export var item_type: ItemType = ItemType.MISC
