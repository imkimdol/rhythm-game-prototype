extends Node

var map_path := ""
var song_path := ""
var bpm:= 120

func read_map_file(path: String) -> Dictionary:
	var file = FileAccess.open(path, FileAccess.READ)
	var json_string = file.get_as_text()
	return JSON.parse_string(json_string)
