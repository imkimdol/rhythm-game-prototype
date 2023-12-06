extends Node

var touching_mouse := 0
var mouse_is_grabbing := false
var camera: Camera2D

func calculate_mouse_pos(event_pos: Vector2) -> Vector2:
	return event_pos - (get_viewport().get_visible_rect().size / 2) + camera.position
