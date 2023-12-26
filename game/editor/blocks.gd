class_name EditorBlocks extends CanvasGroup

var block_scene = preload("res://game/editor/editor_block.tscn")

func reset():
	for block in get_children():
		block.queue_free()

func reconstruct_blocks(blocks_array: Array):
	for block_data in blocks_array:
		var new_block = block_scene.instantiate()
		add_child(new_block)
		new_block.reconstruct(block_data)
	
	check_highest_block()

func new_block(pos: Vector2):
	var block = block_scene.instantiate()
	add_child(block)
	block.deleted.connect(_on_block_deleted)
	block.position = Editor.round_coords(pos)
	
	check_highest_block()
	
func _on_block_deleted():
	check_highest_block()

func check_highest_block():
	Editor.highest_block = -880
	
	for block in get_children():
		if block.is_in_group("block") && !block.is_queued_for_deletion:
			block.check_highest_block()


