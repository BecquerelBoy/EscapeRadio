extends Control

const MAIN_MENU = preload("res://Scene/main_menu.tscn")

func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)
