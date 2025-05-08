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
		"no": 3,
		"choice_yes": "bonne ref mdr",
		"choice_no": "vrmt ntm"
	},
	2: {
		"text": "perso je prend shadowflame",
		"yes": 4,
		"no": 5,
		"choice_yes": "et les rm ?",
		"choice_no": "change d'item"
	},
	3: {
		"text": "Rooh aller c'est pas si mal surtout qu'avec shadowflame ca monte a 14, comme j'ai les botte ca fait 14+16 ca fait 30",
		"yes": 6,
		"no": 7,
		"choice_yes": ":/",
		"choice_no": "tro rigolo"
	},
	4: {"text": "je prend +10 de rm et je prend la bot"},
	5: {"text": "Nope la vie ca pue sa mere"},
	6: {"text": "t'es pas drole"},
	7: {"text": "KYS"}
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
