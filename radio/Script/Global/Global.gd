extends Node

var Frequence : float
var ok : bool = false
var texte_en_cours : bool = false
var current_text : int = 0
var textes : Dictionary = {
	1: "En gros luden c'est un mythique euhh passive mythique",
	2: "Voici un autre texte à afficher.", #choix 1, oui
	3: "Un texte supplémentaire que tu veux afficher sur le label.", #choix 1, oui
	4: "oui j'adore la vie :D", #choix 2.1, oui
	5: "Nope la vie ca pue sa mere", #choix 2.1, oui
	6: "youhou", #choix 2.2, oui
	7: "KMS" #choix 2.2, non
}

func _process(_delta: float) -> void:
	# Activer/désactiver tous les nœuds du groupe "soirr" selon texte_en_cours
	for node in get_tree().get_nodes_in_group("Bouttons"):
		if node.has_method("set_disabled"):
			node.set_disabled(texte_en_cours)

func afficher_texte_par_numero(numero : int) -> void:
	if textes.has(numero):
		var textebox = get_node("/root/Main/Textebox")  # Ajuste le chemin si besoin
		textebox.afficher(textes[numero], numero)
