extends Control

func _process(delta: float) -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

func _on_quit_pressed():
	get_tree().quit()
