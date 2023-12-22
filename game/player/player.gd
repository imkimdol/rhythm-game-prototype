class_name Player extends Node2D

const default_camera_pos := 0
const default_scale := 1

@onready var blocks := %Blocks
@onready var camera := %Camera2D
@onready var combo_label := %CanvasLayer/VBoxContainer3/Combo
@onready var score_label := %CanvasLayer/VboxContainer/Score

var block = load("res://game/player/player_block.tscn")

static var score := 0
static var combo := 0
static var current_player: Player


#region Events
func _ready():
	load_config()
	var save_data = Global.read_map_file(Global.map_path)
	reconstruct_blocks(save_data.blocks)
	current_player = self

func _on_audio_stream_player_finished():
	EditorGlobal.load_and_restore_editor()

func _input(event):
	if event.is_action_pressed("ui_escape"):
		EditorGlobal.load_and_restore_editor()
#endregion


#region Interface
func load_config():
	var path = "user://config.json"
	if !FileAccess.file_exists(path):
		print("no file exists")
		return
	
	var config_data = Global.read_map_file(path)
	scale.x = config_data.scale
	camera.position.x = config_data.camera_position

func reconstruct_blocks(blocks_array: Array):
	for block_data in blocks_array:
		var new_block = block.instantiate()
		blocks.add_child(new_block)
		new_block.reconstruct(block_data)

func set_labels():
	combo_label.text = "Combo: " + str(PlayerGlobal.combo)
	score_label.text = str(PlayerGlobal.score)

static func increase_score():
	score += int(1000 * (1.0 + float(combo) / 100.0))
	combo += 1
	current_player.set_labels()

static func miss():
	combo = 0
	current_player.set_labels()
#endregion
