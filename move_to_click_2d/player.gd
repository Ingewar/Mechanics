extends CharacterBody2D

@export var speed: float = 300.0
var target_position: Vector2
var is_moving: bool = false
var is_selected: bool = false

func _ready():
	target_position = global_position
	add_to_group("players")

func set_selected(selected: bool):
	is_selected = selected
	modulate = Color.CYAN if selected else Color.WHITE


func move_to_position(pos: Vector2):
	target_position = pos
	is_moving = true

func _physics_process(delta):
	if is_moving:
		var direction = (target_position - global_position).normalized()
		var distance = global_position.distance_to(target_position)
		
		if distance > 5.0:
			velocity = direction * speed
			move_and_slide()
		else:
			velocity = Vector2.ZERO
			global_position = target_position
			is_moving = false
