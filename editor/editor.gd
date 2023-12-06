extends Node2D

var block = preload("res://editor/block.tscn")

func _input(event):
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		
		if mouse_event.button_index == MOUSE_BUTTON_LEFT && mouse_event.pressed && !EditorGlobal.touching_mouse:
			var new_block = block.instantiate()
			add_child(new_block)
			new_block.position = EditorGlobal.calculate_mouse_pos(event.position)
