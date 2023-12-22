extends Node2D

@onready var audio_player := %AudioStreamPlayer
@onready var collision_shape := %BlocksStart/CollisionShape2D

func _physics_process(delta):
	position.y += Block.speed * delta

func _on_blocks_start_area_entered(area):
	if area.is_in_group("song_trigger"):
		collision_shape.disabled = true
		play_song()

func play_song():
	audio_player.playing = true
	audio_player.play()
