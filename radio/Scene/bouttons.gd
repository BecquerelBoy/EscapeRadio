extends Control

@onready var button: Button = $Bouttons/Yes  # Assure-toi que ce chemin est correct

func _on_yes_pressed() -> void:
	Global.afficher_texte_par_numero(2)


func _on_no_pressed() -> void:
	Global.afficher_texte_par_numero(3)
