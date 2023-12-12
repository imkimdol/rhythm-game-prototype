class_name EditorBlock extends Block

@export var highlight: Sprite2D

var editor_block_scene = preload("res://game/editor/editor_block.tscn")
var afterimage_scene = preload("res://game/editor/block_after_image.tscn")

var is_touching_mouse := false
var is_grabbed := false
var is_group_grab := false
var group_grab_diff: Vector2
var afterimage: Sprite2D

func _ready():
	height = Block.HEIGHTS.MIDDLE


func _process(_delta):
	super(_delta)
	
	if is_grabbed:
		if !is_group_grab:
			var mouse_position = EditorGlobal.calculate_mouse_pos(get_viewport().get_mouse_position())
			position = EditorGlobal.round_coords(mouse_position)
		else:
			var mouse_position = EditorGlobal.calculate_mouse_pos(get_viewport().get_mouse_position())
			position = EditorGlobal.round_coords(mouse_position + group_grab_diff)

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
	if EditorGlobal.touching_mouse > 0:
		EditorGlobal.touching_mouse -= 1

func create_afterimage():
	afterimage = afterimage_scene.instantiate()
	get_parent().add_child(afterimage)
	afterimage.position = position
	afterimage.scale = scale

func on_group_grab(diff):
	if Input.is_action_pressed("ui_ctrl"):
		var new_block = editor_block_scene.instantiate()
		get_parent().add_child(new_block)
		new_block.reconstruct(get_save_data())
	
	is_grabbed = true
	is_group_grab = true
	group_grab_diff = diff
	sprite.modulate = Color(1, 1, 1, 0.7)
	
	create_afterimage()

func reconstruct(data: Dictionary):
	super(data)
	check_highest_block()

func check_highest_block():
	if position.y < EditorGlobal.highest_block:
		EditorGlobal.highest_block = position.y


func _input(event):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		
		if !mouse_event.pressed && is_group_grab && !EditorGlobal.mouse_is_holding && mouse_event.button_index == MOUSE_BUTTON_LEFT:
			is_group_grab = false
			is_grabbed = false
			EditorGlobal.mouse_in_use = false
			sprite.modulate = Color("ffffff")
			check_highest_block()
			afterimage.queue_free()
			
			return
		
		if !mouse_event.pressed && is_touching_mouse && !EditorGlobal.mouse_is_holding:
			if mouse_event.button_index == MOUSE_BUTTON_LEFT:
				is_grabbed = !is_grabbed
				sprite.modulate = Color(1, 1, 1, 0.7) if is_grabbed else Color("ffffff")
				EditorGlobal.mouse_in_use = !EditorGlobal.mouse_in_use
				
				if is_grabbed:
					create_afterimage()
				else:
					check_highest_block()
					afterimage.queue_free()
				
			elif mouse_event.button_index == MOUSE_BUTTON_RIGHT && !is_grabbed:
				if EditorGlobal.touching_mouse > 0:
					EditorGlobal.touching_mouse -= 1
				queue_free()
	elif event.is_action_pressed("ui_delete") && (is_grabbed || is_group_grab):
		if EditorGlobal.touching_mouse > 0:
			EditorGlobal.touching_mouse -= 1
		EditorGlobal.mouse_in_use = false
		afterimage.queue_free()
		queue_free()
		
	elif is_touching_mouse || is_group_grab:
		if event.is_action_pressed("ui_left"):
			scale.x -= 0.3
			scale.x = max(0.4, scale.x)
		elif event.is_action_pressed("ui_right"):
			scale.x += 0.3
		elif event.is_action_pressed("ui_block_down"):
			move_down()
		elif event.is_action_pressed("ui_block_up"):
			move_up()


func move_down():
	if height != HEIGHTS.BOTTOM as int:
		height -= 1
		sprite.texture = images[height]

func move_up():
	if height != HEIGHTS.TOP as int:
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
