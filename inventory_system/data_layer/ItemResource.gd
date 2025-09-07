class_name ItemResource extends Resource

@export var id: String
@export var name: String
@export var description: String
@export var icon: Texture2D
@export var stack_size: int = 1
@export var item_type: ItemType

enum ItemType { CONSUMABLE, EQUIPMENT, MATERIAL, QUEST }
