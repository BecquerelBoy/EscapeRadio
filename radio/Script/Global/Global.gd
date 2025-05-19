extends Node

var Frequence: float
var ok: bool = false
var texte_en_cours: bool = false
var current_text: int = 0
var is_pausing: bool = false
var slider_modifiable = true
var reponses_joueur: Array = []
var dialogues := {
	1: {
		"text": "Alors j'ai un code a 4 chiffre je commence par quoi ?",
		"Rep1": 2,
		"Rep2": 2,
		"Rep3": 2,
		"Rep4": 2,
		"Rep5": 2,
		"Rep6": 2,
		"Rep7": 2,
		"Rep8": 2,
		"Rep9": 2
	},
	2: {
		"text": "Ok et maintenant ?",
		"Rep1": 3,
		"Rep2": 3,
		"Rep3": 3,
		"Rep4": 3,
		"Rep5": 3,
		"Rep6": 3,
		"Rep7": 3,
		"Rep8": 3,
		"Rep9": 3
	},
	3: {
		"text": "C'est fait, maintenant quoi ?",
		"Rep1": 4,
		"Rep2": 4,
		"Rep3": 4,
		"Rep4": 4,
		"Rep5": 4,
		"Rep6": 4,
		"Rep7": 4,
		"Rep8": 4,
		"Rep9": 4
	},
	4: {
		"text": "Tres bien et pour le dernier ?",
		"Rep1": 5,
		"Rep2": 5,
		"Rep3": 5,
		"Rep4": 5,
		"Rep5": 5,
		"Rep6": 5,
		"Rep7": 5,
		"Rep8": 5,
		"Rep9": 5
	},
	5: {
		"text": "C'est bon j'ai tout activé je vais voir si il se passe qelques chose",
		"Rep1": 6,
	},
	6: {
		"text": "Lessgo c'est bon :D",
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
		# Réinitialise si on revient au début
		if numero == 1:
			reponses_joueur.clear()

		# Si on s’apprête à afficher le texte 5, on vérifie la combinaison
		if numero == 5:
			if reponses_joueur == [8, 4, 7, 6]:
				numero = 6
			else:
				numero = 1
			reponses_joueur.clear()

		var textebox = get_node("/root/Main/Textebox")
		if textebox == null:
			push_error("Textebox introuvable à /root/Main/Textebox")
			return

		var data = dialogues[numero]
		var text = data.get("text", "")
		textebox.afficher(text, numero)
		current_text = numero
