extends Camera2D

@export var position_label: Label

const speed = 1000
const camera_offset = -480

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func reset():
	position = Vector2(0, camera_offset)
	EditorGlobal.camera = self

func _process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= int(speed * delta)
	elif Input.is_action_pressed("ui_down"):
		position.y += int(speed * delta)
		position.y = min(camera_offset, position.y)
	
	position_label.text = "Camera position: " + str((-1 * position.y) + camera_offset)

func _input(event):
	if event.is_action_pressed("ui_scroll_up"):
		position.y -= speed / 20
	elif event.is_action_pressed("ui_scroll_down"):
		position.y += speed / 20
		position.y = min(camera_offset, position.y)
