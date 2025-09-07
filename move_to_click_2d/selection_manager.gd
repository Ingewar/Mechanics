extends Node

var selected_player: CharacterBody2D = null

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		print_debug("Left mouse button clicked")
		handle_selection()
		
	if Input.is_action_just_pressed("right_click"):
		print_debug("Right mouse clicked")
		handle_movement()
	

func handle_selection():
	var space_state = get_viewport().get_world_2d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var camera = get_viewport().get_camera_2d()
	
	if camera:
		var world_pos = camera.get_global_mouse_position()
		var query := PhysicsPointQueryParameters2D.new()
		query.position = world_pos
		query.collision_mask = 1  # Layer 1
		
		var result = space_state.intersect_point(query)
		
		for collision in result:
			var body = collision.collider
			if body.is_in_group("players"):
				select_player(body)
				break

func handle_movement():
	if selected_player:
		var target_pos = get_viewport().get_mouse_position()
		var camera = get_viewport().get_camera_2d()
		if camera:
			target_pos = camera.get_global_mouse_position()
		selected_player.move_to_position(target_pos)

func select_player(player: CharacterBody2D):
	if selected_player and selected_player != player:
		selected_player.set_selected(false)
	
	selected_player = player
	player.set_selected(true)
