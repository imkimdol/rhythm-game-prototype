class_name Editor extends Node2D

signal select_blocks

@onready var load_dialog := %LoadDialog
@onready var save_dialog := %SaveDialog
@onready var song_dialog := %SongDialog
@onready var bpm_edit := %BPMEdit
@onready var blocks := %Blocks
@onready var grid := %Grid
@onready var camera := %Camera2D
@onready var play_button := %PlayButton
@onready var drag_area := %DragArea
@onready var bpm_label := %Bpm
@onready var file_path_label := %FilePath
@onready var song_path_label := %SongPath

const default_highest_block = -880.0
const default_song_path = ("user://music/kb-draft.mp3")

#region Static
static var touching_mouse: int ## The number of items the mouse is touching
static var mouse_in_use: bool ## Mouse is occupied, cannot be used by anything else
static var mouse_is_dragging: bool
static var mouse_drag_start: Vector2
static var highest_block:= default_highest_block
static var restore_editor := false
static var editor: Editor

static func decrease_touching_mouse():
	if Editor.touching_mouse > 0:
		Editor.touching_mouse -= 1

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
	Editor.restore_editor = true
	Global.load_editor()
	Editor.touching_mouse = 0
#endregion

#region Init
func _ready():
	Editor.editor = self
	
	if Editor.restore_editor:
		restore()
	else:
		reset()

func reset():
	Editor.touching_mouse = 0
	Editor.mouse_in_use = false
	Editor.mouse_is_dragging = false
	
	set_bpm(120)
	set_map_path("")
	set_song_path(default_song_path)
	
	camera.reset()
	blocks.reset()
	play_button.disabled = true


func restore():
	load_map(Global.map_path)
#endregion

#region Helpers
func exit_editor():
	Global.load_title()
	Editor.restore_editor = false

func calculate_mouse_pos(event_pos: Vector2) -> Vector2:
	return event_pos - (get_viewport().get_visible_rect().size / 2) + camera.position

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

func handle_mouse_event(event: InputEventMouseButton):
	if event.button_index == MOUSE_BUTTON_LEFT && !Editor.touching_mouse && !Editor.mouse_in_use:
		handle_left_button(event)

func handle_left_button(event: InputEventMouseButton):
	if event.pressed:
		Editor.mouse_drag_start = calculate_mouse_pos(event.position)
		Editor.mouse_is_dragging = true
	else:
		if drag_area.calculate_area() > 500:
			select_blocks.emit()
		else:
			var mouse_pos = calculate_mouse_pos(event.position)
			blocks.new_block(mouse_pos)
		Editor.mouse_is_dragging = false
#endregion

#region Data
func new_map():
	reset()

func load_map(path):
	if !FileAccess.file_exists(path):
		print("no file exists")
		return
	
	var save_data = Global.read_map_file(path)
	
	reset()
	set_map_path(path)
	set_song_path(save_data.song_path)
	set_bpm(save_data.bpm)
	
	camera.position.y = save_data.camera_pos
	blocks.reconstruct_blocks(save_data.blocks)

func load_map_prompt():
	DirAccess.make_dir_absolute("user://maps")
	load_dialog.root_subfolder = "maps"
	load_dialog.visible = true

func save_map(path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_string = JSON.stringify(get_save_data(), "\t")
	file.store_string(json_string)
	file.close()
	set_map_path(path)

func save_map_prompt():
	if Global.map_path == "":
		save_as_map_prompt()
	else:
		save_map(Global.map_path)

func save_as_map_prompt():
	DirAccess.make_dir_absolute("user://maps")
	save_dialog.root_subfolder = "maps"
	save_dialog.visible = true

func pick_song_prompt():
	DirAccess.make_dir_absolute("user://music")
	song_dialog.root_subfolder = "music"
	song_dialog.visible = true

func play_map():
	save_map_prompt()
	if Global.map_path == "":
		return
	Global.load_player()

func set_map_path(path: String):
	play_button.disabled = false
	Global.map_path = path
	file_path_label.text = path

func set_song_path(path: String):
	Global.song_path = path
	song_path_label.text = path

func set_bpm(bpm: int):
	if bpm <= 200:
		Global.bpm = bpm
	grid.place_grid_bars()
	bpm_label.text = str(bpm) + " bpm"
	bpm_edit.text = str(bpm)
#endregion

#region Input Events
func _input(event):
	if event.is_action_pressed("fix_editor"):
		reset()
	elif event is InputEventMouseButton:
		handle_mouse_event(event as InputEventMouseButton)
	else:
		if event.is_action_pressed("ui_new"):
			new_map()
		elif event.is_action_pressed("ui_load"):
			load_map_prompt()
		elif event.is_action_pressed("ui_save"):
			save_map_prompt()
		elif event.is_action_pressed("ui_play"):
			play_map()
		elif event.is_action_pressed("ui_escape"):
			exit_editor()

func _on_new_button_pressed():
	new_map()

func _on_load_button_pressed():
	load_map_prompt()

func _on_save_button_pressed():
	save_map_prompt()

func _on_save_as_button_pressed():
	save_as_map_prompt()

func _on_song_button_pressed():
	pick_song_prompt()

func _on_play_button_pressed():
	play_map()

func _on_load_dialog_file_selected(path):
	load_map(path)

func _on_save_dialog_file_selected(path):
	save_map(path)

func _on_song_dialog_file_selected(path):
	set_song_path(path)

func _on_text_edit_text_submitted(new_text):
	var conv = int(new_text)
	if conv:
		set_bpm(conv)
#endregion
