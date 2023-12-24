class_name PlayerKey extends Node2D

@export var assigned_height: Block.HEIGHTS
@export var assigned_key: Key

@onready var animation_player := %AnimationPlayer
@onready var collision_area := %Area2D

@onready var group_name = Block.height_group_prefix + str(assigned_height)

var block_was_hit := false

func _input(_event):
	if Input.is_key_pressed(assigned_key):
		flash()
		check_for_blocks()

func check_for_blocks():
	block_was_hit = false
	
	for area in collision_area.get_overlapping_areas():
		if area.is_in_group(group_name):
			var block = area.get_parent()
			on_block_hit(block)
	
	if !block_was_hit:
		Player.miss()

func on_block_hit(block: PlayerBlock):
	Player.increase_score()
	block.on_hit()
	block_was_hit = true

func flash():
	animation_player.stop()
	animation_player.play("flash")
