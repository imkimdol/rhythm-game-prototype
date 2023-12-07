class_name EditorBlock extends Block

@export var highlight: Sprite2D

var is_touching_mouse := false
var is_grabbed := false


func _process(_delta):
	super(_delta)
	
	if is_grabbed:
		var mouse_position = EditorGlobal.calculate_mouse_pos(get_viewport().get_mouse_position())
		position = EditorGlobal.round_coords(mouse_position)

func _on_area_2d_mouse_entered():
	if is_grabbed:
		is_touching_mouse = true
		sprite.modulate = Color(1, 1, 1, 0.7)
	elif !EditorGlobal.mouse_in_use:
		is_touching_mouse = true
		highlight.visible = true
	
	EditorGlobal.touching_mouse += 1

func _on_area_2d_mouse_exited():
	is_touching_mouse = false
	highlight.visible = false
	sprite.modulate = Color("ffffff")
	EditorGlobal.touching_mouse -= 1

func _input(event):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		
		if mouse_event.pressed && is_touching_mouse:
			if mouse_event.button_index == MOUSE_BUTTON_LEFT:
				sprite.modulate = Color(1, 1, 1, 0.7)
				is_grabbed = !is_grabbed
				EditorGlobal.mouse_in_use = !EditorGlobal.mouse_in_use
			elif mouse_event.button_index == MOUSE_BUTTON_RIGHT:
				EditorGlobal.touching_mouse -= 1
				queue_free()
	elif event.is_action_pressed("ui_left"):
		if is_grabbed:
			scale.x -= 0.3
			scale.x = max(0.4, scale.x)
	elif event.is_action_pressed("ui_right"):
		if is_grabbed:
			scale.x += 0.3
	elif event.is_action_pressed("ui_block_down"):
		if is_grabbed:
			move_down()
	elif event.is_action_pressed("ui_block_up"):
		if is_grabbed:
			move_up()


func move_down():
	if height != HEIGHTS.DOWN as int:
		height -= 1
		sprite.texture = images[height]

func move_up():
	if height != HEIGHTS.UP as int:
		height += 1
		sprite.texture = images[height]


func get_save_data() -> Dictionary:
	return {
		"pos_x": position.x,
		"pos_y": position.y,
		"scale_x": scale.x,
		"scale_y": scale.y,
		"height": height
	}
