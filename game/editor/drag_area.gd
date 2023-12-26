extends Sprite2D

func calculate_area():
	var original_pos = Editor.mouse_drag_start
	var current_pos = Editor.editor.calculate_mouse_pos(get_viewport().get_mouse_position())
	var diff = current_pos - original_pos
	return abs(diff.x * diff.y)

func _process(_delta):
	var original_pos = Editor.mouse_drag_start
	var current_pos = Editor.editor.calculate_mouse_pos(get_viewport().get_mouse_position())
	var diff = current_pos - original_pos
	
	if Editor.mouse_is_dragging == true:
		position = original_pos + (diff / 2)
		
		scale.x = diff.x / 128
		scale.y = diff.y / 128
		
		visible = true
	else:
		visible = false

func _on_editor_select_blocks():
	for area in $Area2D.get_overlapping_areas():
		if area.is_in_group("block"):
			var block = area.get_parent()
			var diff = block.position - Editor.mouse_drag_start
			block.on_group_grab(diff)
			Editor.mouse_in_use = true
	
	position = Vector2(0, 10000)
