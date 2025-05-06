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

# Fonction pour démarrer l'affichage du texte selon un numéro
func afficher_texte_par_numero(numero : int) -> void:
	if textes.has(numero):
		var textebox = get_node("/root/Main/Textebox")  # Ajuste le chemin si besoin
		textebox.afficher( textes[numero] )  # Appelle une méthode du script Textebox
