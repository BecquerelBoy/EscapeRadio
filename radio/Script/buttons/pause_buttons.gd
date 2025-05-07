extends Control

@onready var fleche_haut: Button = $Fleche_haut
@onready var fleche_bas: Button = $Fleche_bas
@onready var pause: Button = $Pause
@onready var pause_menu: Control = $"../Pause_Menu"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	fleche_haut.disabled = true
	fleche_bas.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_pause_pressed() -> void:
	pause_menu.visible = true
	get_tree().paused = true
