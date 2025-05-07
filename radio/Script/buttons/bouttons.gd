extends Control

@onready var yes = $Yes
@onready var no = $No
@onready var click = $Click


func _on_yes_pressed() -> void:
	click.play()
	var next = Global.current_text * 2
	Global.afficher_texte_par_numero(next)

func _on_no_pressed() -> void:
	click.play()
	var next = Global.current_text * 2 + 1
	Global.afficher_texte_par_numero(next)
