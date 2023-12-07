extends Node2D

@export var blocks: Node2D
var block = preload("res://player/player_block.tscn")

func _ready():
	var save_data = Global.read_map_file(Global.map_path)
	reconstruct_blocks(save_data.blocks)

func reconstruct_blocks(blocks_array: Array):
	for block_data in blocks_array:
		var new_block = block.instantiate()
		blocks.add_child(new_block)
		new_block.reconstruct(block_data)
