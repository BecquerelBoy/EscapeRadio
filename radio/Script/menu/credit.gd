extends Control

const MAIN_MENU = preload("res://Scene/main_menu.tscn")

func _on_button_pressed() -> void:
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(MAIN_MENU)
