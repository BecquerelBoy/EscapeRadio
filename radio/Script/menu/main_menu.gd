extends Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_quit_pressed():
	get_tree().quit()
