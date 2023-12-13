extends Node

var score := 0
var combo := 0
var player

func _ready():
	var path = "user://config.json"
	
	if !FileAccess.file_exists(path):
		var default_config = {
			"camera_position": 0,
			"scale": 1
		}
		
		var file = FileAccess.open(path, FileAccess.WRITE)
		var json_string = JSON.stringify(default_config, "\t")
		file.store_string(json_string)
		file.close()

func increase_score():
	score += int(1000 * (1.0 + float(combo) / 100.0))
	combo += 1
	player.set_labels()

func miss():
	combo = 0
	player.set_labels()
