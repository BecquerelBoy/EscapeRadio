extends Node

var Frequence: float
var ok: bool = false
var texte_en_cours: bool = false
var current_text: int = 0
var is_pausing: bool = false
var slider_modifiable = true
var reponses_joueur: Array = []
var code_correct := false

var dialogues := {
	1: {
		"text": "J'suis dans une pièce avec quatre grandes statues. Aphrodite, Apollon, Hadès et Zeus. Au centre, y'a dix boutons gravés en chiffres romains I à X. Ils s'allument quand je les touche. On dirait qu'on peut en presser quatre. Je presse lequelle en premier ?",
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
		"text": "Très bien, et pour le dernier ?",
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
		"text": "C'est bon j'ai tout activé, je vais voir si il se passe quelque chose",
		"Rep1": 6,
	},
	6: {
		"text": "Lessgo c'est bon :D\nLa pièce dans laquelle je me trouve a une rose des vents au sol.\nLe nord est indiqué face à moi.\nIl y a trois portes devant moi. Je prends laquelle ?"
	},
	7: {
		"text": "Ça ne marche pas.",
		"Rep1": 1
	}
}

func _process(_delta: float) -> void:
	for node in get_tree().get_nodes_in_group("Bouttons"):
		if node.has_method("set_disabled"):
			node.set_disabled(texte_en_cours)

func afficher_texte_par_numero(numero: int) -> void:
	if dialogues.has(numero):

		# Si on revient au tout début
		if numero == 1:
			reponses_joueur.clear()
			code_correct = false

		# Texte 5 toujours affiché après les 4 entrées
		if numero == 5:
			code_correct = reponses_joueur == [8, 4, 7, 6]
			reponses_joueur.clear()  # On réinitialise les réponses

		# Si on vient de valider le texte 5 par bouton
		if numero == 6 or numero == 7:
			current_text = numero
		elif numero == 5 and current_text == 4:
			current_text = 5
		else:
			current_text = numero

		var textebox = get_node("/root/Main/Textebox")
		if textebox == null:
			push_error("Textebox introuvable à /root/Main/Textebox")
			return

		var data = dialogues[numero]

		# Redirection dynamique pour texte 5 vers 6 ou 7
		if numero == 5:
			if code_correct:
				data["Rep1"] = 6
			else:
				data["Rep1"] = 7

		var text = data.get("text", "")
		textebox.afficher(text, numero)
