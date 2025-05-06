extends Node

var Frequence : float
var ok : bool = false
var texte_en_cours : bool = false

var textes : Dictionary = {
	1: "En gros luden c'est un mythique euhh passive mythique",
	2: "Voici un autre texte à afficher.",
	3: "Un texte supplémentaire que tu veux afficher sur le label."
}

func _process(_delta: float) -> void:
	# Activer/désactiver tous les nœuds du groupe "soirr" selon texte_en_cours
	for node in get_tree().get_nodes_in_group("Bouttons"):
		if node.has_method("set_disabled"):
			node.set_disabled(texte_en_cours)

func afficher_texte_par_numero(numero : int) -> void:
	if textes.has(numero):
		var textebox = get_node("/root/Main/Textebox")  # Ajuste le chemin si besoin
		textebox.afficher(textes[numero])
