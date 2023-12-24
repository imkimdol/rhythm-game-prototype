class_name Editor extends Node2D

signal select_blocks

@onready var load_dialog := %LoadDialog
@onready var save_dialog := %SaveDialog
@onready var song_dialog := %SongDialog
@onready var bpm_edit := %CanvasLayer/BPMEdit
@onready var blocks := %Blocks
@onready var camera := %Camera2D
@onready var play_button := %CanvasLayer/HBoxContainer/PlayButton
@onready var drag_area := %DragArea
@onready var bpm_label := %CanvasLayer/VBoxContainer/Bpm
@onready var file_path_label := %CanvasLayer/VBoxContainer/FilePath
@onready var song_path_label := %CanvasLayer/VBoxContainer/SongPath

var player = preload("res://game/player/player.tscn")
var block = preload("res://game/editor/editor_block.tscn")

const default_song_path = ("user://music/kb-draft.mp3")

func _ready():
	Editor.editor = self
	
	if Editor.restore_editor:
		restore()
	else:
		reset()
	
func restore():
	_on_load_dialog_file_selected(Global.map_path)

func reset():
	set_bpm(120)
	set_map_path("")
	set_song_path(default_song_path)
	play_button.disabled = true
	
	for block in blocks.get_children():
		block.queue_free()
	
	camera.reset()
	
	touching_mouse = 0
	mouse_in_use = false
	mouse_is_holding = false

func check_highest_block_all():
	Editor.highest_block = -880
	
	for block in blocks.get_children():
		if block.is_in_group("block") && !block.will_queue_for_death:
			block.check_highest_block()



func _input(event):
	if event.is_action_pressed("fix_editor"):
		reset()
	
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && !Editor.touching_mouse && !Editor.mouse_in_use:
			if mouse_event.pressed:
				Editor.mouse_drag_start = calculate_mouse_pos(event.position)
				Editor.mouse_is_holding = true
				
			elif !mouse_event.pressed:
				if drag_area.calculate_area() > 500:
					select_blocks.emit()
				else:
					var new_block = block.instantiate()
					blocks.add_child(new_block)
					var mouse_pos = calculate_mouse_pos(event.position)
					new_block.position = Editor.round_coords(mouse_pos)
					new_block.check_highest_block()
				
				Editor.mouse_is_holding = false
	else:
		if event.is_action_pressed("ui_new"):
			new_map()
		elif event.is_action_pressed("ui_load"):
			load_map()
		elif event.is_action_pressed("ui_save"):
			save_map()
		elif event.is_action_pressed("ui_play"):
			play_map()
		elif event.is_action_pressed("ui_escape"):
			Global.load_title()





func new_map():
	reset()

func load_map():
	DirAccess.make_dir_absolute("user://maps")
	load_dialog.root_subfolder = "maps"
	load_dialog.visible = true

func save_map():
	if Global.map_path == "":
		_on_save_as_button_pressed()
	else:
		_on_save_dialog_file_selected(Global.map_path)

func play_map():
	save_map()
	if Global.map_path == "":
		return
	get_tree().change_scene_to_packed(player)





func set_map_path(path: String):
	play_button.disabled = false
	Global.map_path = path
	file_path_label.text = path

func set_song_path(path: String):
	Global.song_path = path
	song_path_label.text = path

func set_bpm(bpm: int):
	Global.bpm = bpm
	bpm_label.text = str(bpm) + " bpm"
	bpm_edit.text = str(bpm)

func reconstruct_blocks(blocks_array: Array):
	for block_data in blocks_array:
		var new_block = block.instantiate()
		blocks.add_child(new_block)
		new_block.reconstruct(block_data)

func get_save_data() -> Dictionary:
	var blocks_data = []
	
	for block in blocks.get_children():
		blocks_data.append(block.get_save_data())
	
	return {
		"bpm": Global.bpm,
		"song_path": Global.song_path,
		"camera_pos": camera.position.y,
		"blocks": blocks_data
	}





func _on_new_button_pressed():
	new_map()

func _on_load_button_pressed():
	load_map()

func _on_save_button_pressed():
	save_map()

func _on_save_as_button_pressed():
	DirAccess.make_dir_absolute("user://maps")
	save_dialog.root_subfolder = "maps"
	save_dialog.visible = true

func _on_song_button_pressed():
	DirAccess.make_dir_absolute("user://music")
	song_dialog.root_subfolder = "music"
	song_dialog.visible = true

func _on_play_button_pressed():
	play_map()

func _on_load_dialog_file_selected(path):
	if !FileAccess.file_exists(path):
		print("no file exists")
		return
	
	var save_data = Global.read_map_file(path)
	
	reset()
	set_map_path(path)
	set_song_path(save_data.song_path)
	set_bpm(save_data.bpm)
	
	camera.position.y = save_data.camera_pos
	reconstruct_blocks(save_data.blocks)

func _on_save_dialog_file_selected(path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_string = JSON.stringify(get_save_data(), "\t")
	file.store_string(json_string)
	file.close()
	set_map_path(path)

func _on_song_dialog_file_selected(path):
	set_song_path(path)

func _on_text_edit_text_submitted(new_text):
	var conv = int(new_text)

	if conv:
		set_bpm(conv)

func calculate_mouse_pos(event_pos: Vector2) -> Vector2:
	return event_pos - (get_viewport().get_visible_rect().size / 2) + camera.position


#region Static
static var touching_mouse: int
static var mouse_in_use: bool
static var mouse_is_holding: bool
static var mouse_drag_start: Vector2
static var highest_block:= -880
static var restore_editor := false
static var editor: Editor

static func round_coords(coords: Vector2) -> Vector2:
	var x_comp := float(coords.x)
	var y_comp := float(coords.y)
	
	x_comp = x_comp / 64
	y_comp = y_comp / 32
	
	x_comp = round(x_comp)
	y_comp = round(y_comp)
	
	x_comp = int(x_comp) * 64
	y_comp = int(y_comp) * 32 
	
	x_comp = min(960, x_comp)
	x_comp = max(-960, x_comp)
	y_comp = min(0, y_comp)
	
	return Vector2(x_comp, y_comp)

static func load_and_restore_editor():
	Global.load_editor()
	restore_editor = true
	touching_mouse = 0
#endregion
