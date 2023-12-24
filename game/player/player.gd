class_name Player extends Node2D

const default_camera_pos := 0
const default_scale := 1

@onready var blocks := %Blocks
@onready var camera := %Camera2D
@onready var combo_label := %Combo
@onready var score_label := %Score

var block = preload("res://game/player/player_block.tscn")


#region Events
func _ready():
	Player.player = self
	load_config()
	var save_data = Global.read_map_file(Global.map_path)
	reconstruct_blocks(save_data.blocks)

func _on_audio_stream_player_finished():
	Editor.load_and_restore_editor()

func _input(event):
	if event.is_action_pressed("ui_escape"):
		Editor.load_and_restore_editor()
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
	combo_label.text = "Combo: " + str(Player.combo)
	score_label.text = str(Player.score)
#endregion


#region Static
static var score := 0
static var combo := 0
static var player: Player

static func increase_score():
	Player.score += int(1000 * (1.0 + float(combo) / 100.0))
	Player.combo += 1
	Player.player.set_labels()

static func miss():
	Player.combo = 0
	Player.player.set_labels()
#endregion
