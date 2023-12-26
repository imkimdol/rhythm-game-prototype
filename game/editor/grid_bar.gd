class_name GridBar extends Sprite2D

signal entered_or_exited_screen

func _on_visible_on_screen_notifier_2d_screen_entered():
	entered_or_exited_screen.emit()

func _on_visible_on_screen_notifier_2d_screen_exited():
	entered_or_exited_screen.emit()
