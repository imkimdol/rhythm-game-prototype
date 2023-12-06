extends Node2D

@export var sprite: Sprite2D
@export var highlight: Sprite2D

var is_touching_mouse := false
var is_grabbed := false

enum HEIGHTS {DOWN, MIDDLE, UP}
var height := HEIGHTS.MIDDLE

var purple_image = preload("res://purple.png")
var salmon_image = preload("res://salmon.png")
var teal_image = preload("res://teal.png")
var images = [salmon_image, purple_image, teal_image]

func _process(_delta):
	if is_grabbed:
		position = EditorGlobal.calculate_mouse_pos(get_viewport().get_mouse_position())

func _on_area_2d_mouse_entered():
	if is_grabbed:
		is_touching_mouse = true
		sprite.modulate = Color(1, 1, 1, 0.7)
	elif !EditorGlobal.mouse_is_grabbing:
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
				EditorGlobal.mouse_is_grabbing = !EditorGlobal.mouse_is_grabbing
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
	if height != HEIGHTS.DOWN:
		height -= 1
		sprite.texture = images[height]

func move_up():
	if height != HEIGHTS.UP:
		height += 1
		sprite.texture = images[height]
