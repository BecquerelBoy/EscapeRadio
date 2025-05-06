extends Node

# Fréquence et variable de contrôle
var Frequence : float
var ok : bool = false

# Dictionnaire de textes associés à des nombres
var textes : Dictionary = {
	1: "En gros luden c'est un mythique euhh passive mythique",
	2: "Voici un autre texte à afficher.",
	3: "Un texte supplémentaire que tu veux afficher sur le label."
}

# Fonction pour démarrer l'affichage du texte selon un nombre
func afficher_texte_par_numero(numero : int) -> void:
	if textes.has(numero):  # Vérifier si le numéro existe dans le dictionnaire
		var texte_a_afficher = textes[numero]
		var label = get_node("/root/Menu/MarginContainer/VBoxContainer/Text")  # Accède au label
		var script_label = label.get_script()  # Accède au script du label
		script_label.full_text = texte_a_afficher
		script_label.start_text_display()  # Démarre l'affichage du texte
