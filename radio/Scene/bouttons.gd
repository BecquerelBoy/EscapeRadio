extends Control

@onready var button_yes: Button = $Bouttons/Yes
@onready var button_no: Button = $Bouttons/No

func _on_yes_pressed() -> void:
	var next = Global.current_text * 2
	Global.afficher_texte_par_numero(next)

func _on_no_pressed() -> void:
	var next = Global.current_text * 2 + 1
	Global.afficher_texte_par_numero(next)
