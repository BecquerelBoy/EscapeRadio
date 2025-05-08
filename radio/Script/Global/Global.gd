extends Node

var Frequence : float
var ok : bool = false
var texte_en_cours : bool = false
var current_text : int = 0
var is_pausing : bool = false
var dialogues := {
	1: {
		"text": "En gros luden c'est un mythique euhh passive mythique",
		"yes": 2,
		"no": 3
	},
	2: {
		"text": "Voici un autre texte à afficher.",
		"yes": 4,
		"no": 5
	},
	3: {
		"text": "Un texte supplémentaire que tu veux afficher sur le label.",
		"yes": 6,
		"no": 7
	},
	4: {"text": "oui j'adore la vie :D"},
	5: {"text": "Nope la vie ca pue sa mere"},
	6: {"text": "youhou"},
	7: {"text": "KMS"}
}


func _process(_delta: float) -> void:
	# Activer/désactiver tous les nœuds du groupe "Bouttons" selon texte_en_cours
	for node in get_tree().get_nodes_in_group("Bouttons"):
		if node.has_method("set_disabled"):
			node.set_disabled(texte_en_cours)

func afficher_texte_par_numero(numero : int) -> void:
	if dialogues.has(numero):
		var textebox = get_node("/root/Main/Textebox")
		var data = dialogues[numero]
		var text = data.get("text", "")
		textebox.afficher(text, numero)
		current_text = numero
