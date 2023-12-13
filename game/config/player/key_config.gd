class_name PlayerKeyConfig extends PlayerKey

func _input(event):
	if Input.is_key_pressed(assigned_key):
		flash()
