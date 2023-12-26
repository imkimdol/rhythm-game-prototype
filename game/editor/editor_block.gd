class_name EditorBlock extends Block

signal deleted

@onready var highlight := %Highlight

var editor_block_scene = preload("res://game/editor/editor_block.tscn")
var afterimage_scene = preload("res://game/editor/block_after_image.tscn")

var group_grab_diff: Vector2
var afterimage: Sprite2D

var is_touching_mouse := false
var is_grabbed := false
var is_group_grab := false
var is_queued_for_deletion := false

func _process(_delta):
	super(_delta)
	
	if is_grabbed:
		go_to_mouse()

#region Instance
func _ready():
	height = Block.HEIGHTS.MIDDLE

func reconstruct(data: Dictionary):
	super(data)
	check_highest_block()

func copy():
	var new_block = editor_block_scene.instantiate()
	get_parent().add_child(new_block)
	new_block.reconstruct(get_save_data())

func delete():
	Editor.decrease_touching_mouse()
	Editor.mouse_in_use = false
	
	delete_afterimage()
	
	is_queued_for_deletion = true
	deleted.emit()
	queue_free()

func create_afterimage():
	afterimage = afterimage_scene.instantiate()
	get_parent().add_child(afterimage)
	afterimage.position = position
	afterimage.scale = scale

func delete_afterimage():
	if afterimage:
		afterimage.queue_free()
		afterimage = null
#endregion

#region Handle Input
func _input(event):
	if event is InputEventMouseButton:
		handle_mouse_input(event as InputEventMouseButton)
	elif event.is_action_pressed("ui_delete") && (is_grabbed || is_group_grab):
		delete()
	elif is_touching_mouse || is_group_grab:
		if event.is_action_pressed("ui_a"):
			scale_down()
		elif event.is_action_pressed("ui_d"):
			scale_up()
		elif event.is_action_pressed("ui_block_down"):
			move_down()
		elif event.is_action_pressed("ui_block_up"):
			move_up()

func handle_mouse_input(event: InputEventMouseButton):
	if !event.pressed:
		handle_unclick(event)

func handle_unclick(event: InputEventMouseButton):
	var is_group_ungrab = is_group_grab and !Editor.mouse_is_dragging and event.button_index == MOUSE_BUTTON_LEFT
	
	if is_group_ungrab:
		on_ungrab()
	elif is_touching_mouse and !Editor.mouse_is_dragging:
		var is_left_click = event.button_index == MOUSE_BUTTON_LEFT
		var is_right_click = event.button_index == MOUSE_BUTTON_RIGHT
		
		if is_left_click:
			if !is_grabbed:
				on_grab()
			else:
				on_ungrab()
		elif is_right_click and !is_grabbed:
			delete()

func _on_area_2d_mouse_entered():
	on_hover()

func _on_area_2d_mouse_exited():
	on_unhover()
#endregion

#region Input Functions
func go_to_mouse():
	var mouse_position = Editor.editor.calculate_mouse_pos(get_viewport().get_mouse_position())
	if is_group_grab:
		position = Editor.round_coords(mouse_position + group_grab_diff)
	else:
		position = Editor.round_coords(mouse_position)

func on_grab():
	if Input.is_action_pressed("ui_ctrl"):
		copy()
	
	is_grabbed = true
	Editor.mouse_in_use = true
	 
	sprite.modulate = Color(1, 1, 1, 0.7)
	create_afterimage()

func on_group_grab(diff):
	on_grab()
	is_group_grab = true
	group_grab_diff = diff

func on_hover():
	if is_grabbed:
		is_touching_mouse = true
		sprite.modulate = Color(1, 1, 1, 0.7)
	elif !Editor.mouse_in_use:
		is_touching_mouse = true
		highlight.visible = true
	
	Editor.touching_mouse += 1

func on_unhover():
	is_touching_mouse = false
	highlight.visible = false
	if Editor.touching_mouse > 0:
		Editor.touching_mouse -= 1

func on_ungrab():
	is_group_grab = false
	is_grabbed = false
	Editor.mouse_in_use = false
	
	sprite.modulate = Color("ffffff")
	check_highest_block()
	delete_afterimage()



func check_highest_block():
	if position.y < Editor.highest_block:
		Editor.highest_block = position.y
#endregion

#region Data
func scale_down():
	scale.x -= 0.3
	scale.x = max(0.4, scale.x)

func scale_up():
	scale.x += 0.3

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
#endregion
