class_name PlayerBlock extends Block

@onready var area := %Area2D
@onready var collision_shape := %Area2D/CollisionShape2D
@onready var hit_particles := %HitParticles
@onready var death_particles := %DeathParticles
@onready var animation_player := %AnimationPlayer

func _ready():
	super()

func _on_area_2d_area_entered(area):
	if area.is_in_group("block_removal_trigger"):
		on_death()

func on_hit():
	collision_shape.disabled = true
	hit_particles.emitting = true
	animation_player.play("on_hit_or_death")

func on_death():
	PlayerGlobal.miss()
	death_particles.emitting = true
	animation_player.play("on_hit_or_death")

func reconstruct(data: Dictionary):
	super(data)
	
	area.add_to_group(height_group_prefix + str(height))
	
	var color = colors[height] as Color
	hit_particles.color = color
