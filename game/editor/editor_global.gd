extends Node

var touching_mouse: int
var mouse_in_use: bool
var camera: Camera2D
var restore_editor := false

var editor = preload("res://game/editor/editor.tscn")

func _ready():
	reset()

func calculate_mouse_pos(event_pos: Vector2) -> Vector2:
	return event_pos - (get_viewport().get_visible_rect().size / 2) + camera.position

func reset():
	touching_mouse = 0
	mouse_in_use = false

func _input(event):
	if event.is_action_pressed("fix_editor"):
		reset()

func round_coords(coords: Vector2) -> Vector2:
	var x_comp := float(coords.x)
	var y_comp := float(coords.y)
	
	x_comp = x_comp / 64
	y_comp = y_comp / 32
	
	x_comp = round(x_comp)
	y_comp = round(y_comp)
	
	x_comp = int(x_comp) * 64
	y_comp = int(y_comp) * 32 
	
	y_comp = min(0, y_comp)
	
	return Vector2(x_comp, y_comp)

func load_and_restore_editor():
	get_tree().change_scene_to_packed(editor)
	restore_editor = true
	touching_mouse = 0
