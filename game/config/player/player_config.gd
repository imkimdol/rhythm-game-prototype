class_name PlayerConfig extends Player

var title_scene = preload("res://game/title/title.tscn")

func _ready():
	load_config()

func _input(event):
	if event.is_action_pressed("ui_escape"):
		var file = FileAccess.open("user://config.json", FileAccess.WRITE)
		var json_string = JSON.stringify(get_save_data(), "\t")
		file.store_string(json_string)
		file.close()
		
		get_tree().change_scene_to_packed(title_scene)
	elif event.is_action_pressed("ui_up"):
		scale.x += 0.01
	elif event.is_action_pressed("ui_down"):
		scale.x -= 0.01
		scale.x = max(0.4, scale.x)
	elif event.is_action_pressed("ui_space"):
		camera.position.x = 0
		scale.x = 1

func _process(delta):
	if Input.is_action_pressed("ui_left"):
		camera.position.x += 5
	elif Input.is_action_pressed("ui_right"):
		camera.position.x -= 5


func get_save_data() -> Dictionary:
	return {
		"camera_position": camera.position.x,
		"scale": scale.x
	}
