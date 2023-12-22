extends Node

const config_path := "user://config.json"

var title_scene = preload("res://game/title/title.tscn")

var map_path := ""
var song_path := ""
var bpm := 120

func _ready():
	if !FileAccess.file_exists(config_path):
		_create_config_file()

func _create_config_file():
	var default_config = {
		"camera_position": Player.default_camera_pos,
		"scale": Player.default_scale
	}
	
	var file = FileAccess.open(config_path, FileAccess.WRITE)
	var json_string = JSON.stringify(default_config, "\t")
	file.store_string(json_string)
	file.close()

func to_title():
	get_tree().change_scene_to_packed(title_scene)

func read_map_file(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	var json_string = file.get_as_text()
	return JSON.parse_string(json_string)
