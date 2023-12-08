class_name PlayerKey extends Node2D

@export var assigned_height: Block.HEIGHTS
@export var assigned_key: Key

func _input(event):
	if Input.is_key_pressed(assigned_key):
		flash()
		
		var block_was_hit = false
		for area in $Area2D.get_overlapping_areas():
			if area.is_in_group("block_height_" + str(assigned_height)):
				PlayerGlobal.increase_score()
				area.get_parent().on_hit()
				block_was_hit = true
		
		if !block_was_hit:
			PlayerGlobal.miss()

func flash():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("flash")
