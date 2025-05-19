extends Control

@onready var pause_menu: Control = $"."
@onready var fleche_haut = $"../Pause_buttons/Fleche_haut"
@onready var fleche_bas = $"../Pause_buttons/Fleche_bas"
@onready var quit_select: Sprite2D = $quit_select
@onready var resume_select: Sprite2D = $resume_select
@onready var click = $"../Bouttons/Click"
@onready var bouttons: Control = $"../Bouttons"
@onready var ok = $"../Pause_buttons/ok"

func _on_fleche_haut_pressed() -> void:
	click.play()
	resume_select.visible = true
	quit_select.visible = false

func _on_fleche_bas_pressed() -> void:
	click.play()
	resume_select.visible = false
	quit_select.visible = true

func _on_ok_pressed() -> void:
	click.play()
	if resume_select.visible:
		get_tree().paused = false
		pause_menu.visible = false
		Global.is_pausing = false
	elif quit_select.visible:
		Global.is_pausing = false
		get_tree().paused = false
		get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
