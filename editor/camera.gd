extends Camera2D

const speed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	EditorGlobal.camera = self


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if Input.is_action_pressed("ui_up"):
		position.y -= speed * delta
	elif Input.is_action_pressed("ui_down"):
		position.y += speed * delta

func _input(event):
	if event.is_action_pressed("ui_scroll_up"):
		position.y -= speed / 10
	elif event.is_action_pressed("ui_scroll_down"):
		position.y += speed / 10
