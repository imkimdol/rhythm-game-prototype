class_name Player extends Node2D

@export var blocks: Node2D
@export var audio_player: AudioStreamPlayer
@export var combo_label: Label
@export var score_label: Label
@export var camera: Camera2D

var block = load("res://game/player/player_block.tscn")

func _ready():
	load_config()
	var save_data = Global.read_map_file(Global.map_path)
	audio_player.stream = load_mp3(Global.song_path)
	reconstruct_blocks(save_data.blocks)
	PlayerGlobal.player = self

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

func play_song():
	audio_player.playing = true
	audio_player.play()

func load_mp3(path):
	var file = FileAccess.open(path, FileAccess.READ)
	var sound = AudioStreamMP3.new()
	sound.data = file.get_buffer(file.get_length())
	return sound

func _on_audio_stream_player_finished():
	EditorGlobal.load_and_restore_editor()

func _on_blocks_start_area_entered(area):
	if area.is_in_group("song_trigger"):
		play_song()

func _input(event):
	if event.is_action_pressed("ui_escape"):
		EditorGlobal.load_and_restore_editor()
