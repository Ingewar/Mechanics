class_name DragDropObjectType extends Resource

@export var type_name: String = ""
@export var type_id: String = ""
@export var color: Color = Color.WHITE
@export var icon: Texture2D

func _init(name: String = "", id: String = ""):
	type_name = name
	type_id = id
