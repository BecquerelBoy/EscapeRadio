extends Node

var Frequence: float
var ok: bool = false
var texte_en_cours: bool = false
var current_text: int = 0
var is_pausing: bool = false
var slider_modifiable = true

var dialogues := {
	1: {
		"text": "En gros luden c'est un mythique euhh passive mythique",
		"Rep1": 2,
		"Rep2": 3,
		"Rep3": 4,
		"Rep4": 5
	},
	2: {
		"text": "perso je prend shadowflame"
	},
	3: {
		"text": "Rooh aller c'est pas si mal surtout qu'avec shadowflame ca monte a 14, comme j'ai les bottes ca fait 14+16 ca fait 30"
	},
	4: {
		"text": "ok mais t'as oublié les MR mec"
	},
	5: {
		"text": "tu forces là fréro"
	}
}

func _process(_delta: float) -> void:
	# Activer/désactiver tous les nœuds du groupe "Bouttons" selon texte_en_cours
	for node in get_tree().get_nodes_in_group("Bouttons"):
		if node.has_method("set_disabled"):
			node.set_disabled(texte_en_cours)
	
	print(is_pausing)

func afficher_texte_par_numero(numero: int) -> void:
	if dialogues.has(numero):
		var textebox = get_node("/root/Main/Textebox")
		if textebox == null:
			push_error("Textebox introuvable à /root/Main/Textebox")
			return

		var data = dialogues[numero]
		var text = data.get("text", "")
		textebox.afficher(text, numero)
		current_text = numero
