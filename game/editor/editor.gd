class_name Editor extends Node2D

signal select_blocks

@export var load_dialog: FileDialog
@export var save_dialog: FileDialog
@export var song_dialog: FileDialog
@export var bpm_edit: LineEdit
@export var blocks: Node2D
@export var camera: Camera2D
@export var play_button: Button
@export var drag_area: Sprite2D
@export var bpm_label: Label
@export var file_path_label: Label
@export var song_path_label: Label

var player = preload("res://game/player/player.tscn")
var block = preload("res://game/editor/editor_block.tscn")

const default_song_path = ("user://music/kb-draft.mp3")

func _ready():
	EditorGlobal.editor = self
	
	if EditorGlobal.restore_editor:
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
	EditorGlobal.reset()

func check_highest_block_all():
	EditorGlobal.highest_block = -880
	
	for block in blocks.get_children():
		if block.is_in_group("block") && !block.will_queue_for_death:
			block.check_highest_block()



func _input(event):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && !EditorGlobal.touching_mouse && !EditorGlobal.mouse_in_use:
			if mouse_event.pressed:
				EditorGlobal.mouse_drag_start = EditorGlobal.calculate_mouse_pos(event.position)
				EditorGlobal.mouse_is_holding = true
				
			elif !mouse_event.pressed:
				if drag_area.calculate_area() > 500:
					select_blocks.emit()
				else:
					var new_block = block.instantiate()
					blocks.add_child(new_block)
					var mouse_pos = EditorGlobal.calculate_mouse_pos(event.position)
					new_block.position = EditorGlobal.round_coords(mouse_pos)
					new_block.check_highest_block()
				
				EditorGlobal.mouse_is_holding = false
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
			EditorGlobal.load_title()





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
