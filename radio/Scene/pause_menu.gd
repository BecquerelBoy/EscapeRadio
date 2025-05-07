extends Control

@onready var pause_menu: Control = $"."
@onready var fleche_haut: Button = $"../Pause_buttons/Fleche_haut"
@onready var fleche_bas: Button = $"../Pause_buttons/Fleche_bas"

func _ready() -> void:
	fleche_haut.disabled = false
	fleche_bas.disabled = false
	Global.is_pausing = true

func _process(delta: float) -> void:
	pass
