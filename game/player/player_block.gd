class_name PlayerBlock extends Block

func _ready():
	super()

func _on_area_2d_area_entered(area):
	if area.is_in_group("block_removal_trigger"):
		on_death()

func on_hit():
	$Area2D/CollisionShape2D.disabled = true
	$HitParticles.emitting = true
	$AnimationPlayer.play("on_hit_or_death")

func on_death():
	PlayerGlobal.miss()
	$DeathParticles.emitting = true
	$AnimationPlayer.play("on_hit_or_death")

func reconstruct(data: Dictionary):
	super(data)
	
	$Area2D.add_to_group("block_height_" + str(height))
	
	var color = colors[height] as Color
	$HitParticles.color = color
