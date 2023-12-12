extends Node2D

const speed := 512

func _physics_process(delta):
	position.y += speed * delta
