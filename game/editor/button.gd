extends Button

func _on_mouse_entered():
	EditorGlobal.touching_mouse += 1

func _on_mouse_exited():
	if EditorGlobal.touching_mouse > 0:
		EditorGlobal.touching_mouse -= 1
