extends Camera2D

@export var position_label: Label
@export var bounds: Node2D
@export var scroll_bar: VScrollBar

const speed = 2000
const camera_offset = -480

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func reset():
	position = Vector2(0, camera_offset)
	EditorGlobal.camera = self

func _process(delta):
	if Input.is_action_pressed("ui_w"):
		position.y -= int(speed * delta)
	elif Input.is_action_pressed("ui_s"):
		position.y += int(speed * delta)
		position.y = min(camera_offset, position.y)
	
	position_label.text = "Camera position: " + str((-1 * position.y) + camera_offset)
	bounds.position = position
	scroll_bar.value = position.y
	scroll_bar.min_value = EditorGlobal.highest_block

func _input(event):
	if event.is_action_pressed("ui_scroll_up"):
		position.y -= speed / 20
	elif event.is_action_pressed("ui_scroll_down"):
		position.y += speed / 20
		position.y = min(camera_offset, position.y)


func _on_v_scroll_bar_value_changed(value):
	position.y = value
