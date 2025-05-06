extends Control

@onready var button: Button = $Bouttons/Yes  # Assure-toi que ce chemin est correct

func _on_yes_pressed() -> void:
	print("Bouton pressé !")
	
	# Changer le texte (afficher le texte n°2)
	Global.afficher_texte_par_numero(2)
