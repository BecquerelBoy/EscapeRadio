extends Control

@onready var pause_menu: Control = $"."
@onready var fleche_haut: Button = $"../Pause_buttons/Fleche_haut"
@onready var fleche_bas: Button = $"../Pause_buttons/Fleche_bas"
@onready var resume: Button = $Resume

func _ready() -> void:
	fleche_haut.disabled = false
	fleche_bas.disabled = false
	Global.is_pausing = true
	resume.grab_focus()  # Donne le focus dès que le menu est prêt

func _on_resume_pressed() -> void:
	get_tree().paused = false
	pause_menu.visible = false
	Global.is_pausing = false

func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
