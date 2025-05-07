extends Control

@onready var fleche_haut: Button = $Fleche_haut
@onready var fleche_bas: Button = $Fleche_bas
@onready var pause: Button = $Pause
@onready var pause_menu: Control = $"../Pause_Menu"
@onready var resume: Button = $"../Pause_Menu/Resume"
@onready var quit: Button = $"../Pause_Menu/Quit"

func _ready() -> void:
	fleche_haut.disabled = true
	fleche_bas.disabled = true

func _on_pause_pressed() -> void:
	pause_menu.visible = true
	get_tree().paused = true
	resume.grab_focus()  # Focus initial

func _on_fleche_haut_pressed() -> void:
	resume.grab_focus()

func _on_fleche_bas_pressed() -> void:
	quit.grab_focus()
