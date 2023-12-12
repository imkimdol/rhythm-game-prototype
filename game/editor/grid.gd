extends Node2D

@export var camera: Camera2D

var grid_bar_scene = preload("res://game/editor/grid_bar.tscn")

const block_speed = 512

func _ready():
	for n in 50:
		add_child(grid_bar_scene.instantiate())

func _process(delta):
	var counter = -25
	var pixels_per_beat = (block_speed * 60) / Global.bpm
	var rounded_camera_pos = int((camera.position.y - camera.camera_offset) / pixels_per_beat) * pixels_per_beat
	
	for bar in get_children():
		bar.position.y = (-1 * counter * pixels_per_beat) / 4 + rounded_camera_pos
		bar.scale.y = 0.04 if counter % 4 == 0 else 0.01
		counter += 1
