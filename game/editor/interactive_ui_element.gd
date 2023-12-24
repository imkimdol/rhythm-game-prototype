extends Control

func _on_mouse_entered():
	Editor.touching_mouse += 1

func _on_mouse_exited():
	if Editor.touching_mouse > 0:
		Editor.touching_mouse -= 1
