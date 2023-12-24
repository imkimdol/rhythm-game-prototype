class_name Block extends Node2D

@onready var sprite := %Sprite2D

const speed := 512
const height_group_prefix := "block_height_"

enum HEIGHTS {BOTTOM, MIDDLE, TOP}
var height: int

var purple_image = preload("res://assets/textures/purple.png")
var salmon_image = preload("res://assets/textures/salmon.png")
var teal_image = preload("res://assets/textures/teal.png")
var images = [salmon_image, purple_image, teal_image]
const colors = [Color("ff596a"), Color("595eff"), Color("59ffbd")]

func _ready():
	pass

func _process(_delta):
	pass

func reconstruct(data: Dictionary):
	position.x = data.pos_x
	position.y = data.pos_y
	scale.x = data.scale_x
	scale.y = data.scale_y
	height = data.height
	sprite.texture = images[height]
