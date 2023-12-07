extends Node2D

@export var load_dialog: FileDialog
@export var save_dialog: FileDialog
@export var blocks: Node2D
@export var camera: Camera2D
@export var play_button: Button
@export var file_path_label: Label

var player = preload("res://player/player.tscn")
var block = preload("res://editor/editor_block.tscn")


func _ready():
	reset()

func reset():
	set_map_path("")
	play_button.disabled = true
	
	for block in blocks.get_children():
		block.queue_free()
	
	camera.reset()
	EditorGlobal.reset()

func _input(event):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed && !EditorGlobal.touching_mouse && !EditorGlobal.mouse_in_use:
			var new_block = block.instantiate()
			blocks.add_child(new_block)
			var mouse_pos = EditorGlobal.calculate_mouse_pos(event.position)
			new_block.position = EditorGlobal.round_coords(mouse_pos)
	else:
		if event.is_action_pressed("ui_new"):
			new_map()
		elif event.is_action_pressed("ui_load"):
			load_map()
		elif event.is_action_pressed("ui_save"):
			save_map()
		elif event.is_action_pressed("ui_play"):
			play_map()





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
	if Global.map_path == "":
		return
	get_tree().change_scene_to_packed(player)





func set_map_path(path: String):
	play_button.disabled = false
	Global.map_path = path
	file_path_label.text = Global.map_path

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

func _on_play_button_pressed():
	play_map()

func _on_load_dialog_file_selected(path):
	if !FileAccess.file_exists(path):
		print("no file exists")
		return
	
	var save_data = Global.read_map_file(path)
	
	reset()
	set_map_path(path)
	
	camera.position.y = save_data.camera_pos
	reconstruct_blocks(save_data.blocks)

func _on_save_dialog_file_selected(path):
	var file = FileAccess.open(path, FileAccess.WRITE)
	var json_string = JSON.stringify(get_save_data(), "\t")
	file.store_string(json_string)
	file.close()
	set_map_path(path)


