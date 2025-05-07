extends Control

@onready var pause_menu: Control = $"."

func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
