extends Node2D

@export var camera: Camera2D

var grid_bar_scene = preload("res://game/editor/grid_bar.tscn")

const block_speed = 512.0

func _ready():
	for n in 50:
		add_child(grid_bar_scene.instantiate())

func _process(delta):
	var counter = -10
	var pixels_per_beat = (block_speed * 60.0) / float(Global.bpm)
	var rounded_camera_pos = int((camera.position.y - camera.camera_offset) / pixels_per_beat) * pixels_per_beat
	
	for bar in get_children():
		bar.position.y = (-1.0 * counter * pixels_per_beat) / 4.0 + rounded_camera_pos
		bar.visible = bar.position.y <= 0
		
		if counter % 4 == 0:
			bar.scale.y = 0.04
		else:
			bar.scale.y = 0.01
		
		if int(bar.position.y * 4 / int(pixels_per_beat)) % 16 == 0:
			bar.modulate = Color("ffffff78")
		else:
			bar.modulate = Color("ffffff28")
			
		counter += 1
