class_name Block extends Node2D

@export var sprite: Sprite2D

enum HEIGHTS {DOWN, MIDDLE, UP}
var height := HEIGHTS.MIDDLE as int

var purple_image = preload("res://textures/purple.png")
var salmon_image = preload("res://textures/salmon.png")
var teal_image = preload("res://textures/teal.png")
var images = [salmon_image, purple_image, teal_image]

func _process(delta):
	pass

func reconstruct(data: Dictionary):
	position.x = data.pos_x
	position.y = data.pos_y
	scale.x = data.scale_x
	scale.y = data.scale_y
	height = data.height
	sprite.texture = images[height]
