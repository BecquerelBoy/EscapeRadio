extends Control

@onready var fleche_haut = $Fleche_haut
@onready var fleche_bas = $Fleche_bas
@onready var pause = $Pause
@onready var pause_menu: Control = $"../Pause_Menu"
@onready var click = $"../Bouttons/Click"


func _on_pause_pressed() -> void:
	click.play()
	pause_menu.visible = true
	Global.is_pausing = true
	get_tree().paused = true
