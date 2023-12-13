extends Node2D

var config = preload("res://game/config/player/player_config.tscn")

func _on_editor_pressed():
	EditorGlobal.load_editor()

func _on_config_pressed():
	get_tree().change_scene_to_packed(config)
