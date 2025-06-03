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
		"text": "Allô ? Tu m'entends ? ... Ah ! Enfin. J'ai cru que j'étais seul ici.
		\n J'suis descendu il y a un petit moment déja. Je vois enfin le temple.",
		"Rep1": 2
	},
	2: {
		"text": "Il est immense… taillé directement dans la roche, avec des arches effondrées recouvertes d'algues.
		 Y’a des colonnes… elles ont l’air grecques, mais plus massives, comme si elles avaient fusionné avec autre chose… phénicien peut-être.
		Et là… des mosaïques. Des formes géométriques, typiquement méditerranéennes. Comme si plusieurs peuples l'avaient construit ensemble.",
		"Rep1": 3
	},
	3: {
		"text": "Bref assez discuté, je vais m'approcher. L'eau est glacée, mais j'dois être proche de l'entrée. 
		\n Je vois une ouverture. C'est pas très large, j'entre...",
		"Rep1": 4
	},
	4: {
		"text": "On voit rien là-dedans. Laisse-moi sortir ma lampe... Voilà.
		\n Ah d'accord, en fait le temple est sous le plancher marin. Y'a un escalier qui descend.
		J'vais y aller doucement... 
		\n *bruit sourd*",
		"Rep1": 5
	},
	5: {
		"text": "...Bon. Mauvaise nouvelle. L'escalier vient de s'effondrer derrière moi. Pas de retour possible.",
		"Rep1": 6,
	},
	6: {
		"text": "Bon allez on se ressaisit, J'suis dans une pièce avec quatre grandes statues numérotées de 1 à 4 dans l'ordre ça donne : Aphrodite ensuite Apollon puis Hadès et enfin Zeus.
		 Et au centre, neuf boutons gravés en chiffres romains. I à IX. Ils s'allument quand je les touche. On dirait qu'il me faut un code à quatre chiffres...
		 T'aurais une idée de ce que je dois entrer ?",
		"Rep1": 7, "Rep2": 7, "Rep3": 7, "Rep4": 7, "Rep5": 7, "Rep6": 7, "Rep7": 7, "Rep8": 7, "Rep9": 7,
	},
	7: {
		"text": "Ok le premier chiffre s'affiche, je met quoi après ?",
		"Rep1": 8, "Rep2": 8, "Rep3": 8, "Rep4": 8, "Rep5": 8, "Rep6": 8, "Rep7": 8, "Rep8": 8, "Rep9": 8,
	},
	8: {
		"text": "J'ai mis le deuxième, ensuite ?",
		"Rep1": 9, "Rep2": 9, "Rep3": 9, "Rep4": 9, "Rep5": 9, "Rep6": 9, "Rep7": 9, "Rep8": 9, "Rep9": 9,
	},
	9: {
		"text": "Le troisième s'affiche aussi, donne moi le dernier",
		"Rep1": 10, "Rep2": 10, "Rep3": 10, "Rep4": 10, "Rep5": 10, "Rep6": 10, "Rep7": 10, "Rep8": 10, "Rep9": 10
	},
	10: {
		"text": "Les boutons s'allument... ça clignote...",
		"Rep1": 12,     # mauvaise
	},
	11: {
		"text": "Les boutons s'éteignent. Ca n'a pas marché... On réessaie ?",
		"Rep1": 6
	},
	12: {
		"text": "J'entends quelque chose. \n Une dalle vient de coulisser. C'est ouvert !",
		"Rep1": 13
	},
	13: {
		"text": "Je suis dans la nouvelle salle, avec une rose des vents dessinée au sol. Elle indique le nord droit devant. Et il y a trois portes une à gauche,  au milieu et à droite...
		\n Il va falloir que tu m'indique le bon chemin.",
		"Rep1": 14,     # mauvaise
		"Rep2": 15,     # correcte
		"Rep3": 14      # mauvaise
	},
	14: {
		"text": "C'est étrange, je suis... revenu au point de départ. Exactement la même salle qu'au début.
		\n Ok bon... Visiblement, ça marche pas comme un vrai couloir, on retente.",
		"Rep1": 14,     # mauvaise
		"Rep2": 15,     # correcte
		"Rep3": 14      # mauvaise
	},
	15: {
		"text": "Milieu ? Ok... \n Je suis dans la salle suivante. Y'a des fresques anciennes. Je reconnais aucun symbole...
		\n Y'a trois portes de nouveau. Je prend laquelle ?",
		"Rep1": 16,     # correcte
		"Rep2": 14,     # mauvaise
		"Rep3": 14      # mauvaise
	},
	16: {
		"text": "Je suis dans la salle de gauche.
		\n C'est pareil que la salle d'avant j'ai encore trois portes. Je te fais confiance donne moi la bonne.",
		"Rep1": 14,     # mauvaise
		"Rep2": 14,     # mauvaise
		"Rep3": 17      # correcte
	},
	17: {
		"text": "A Droite ? Ca marche... 
		\n Je crois que c'est bon il y a a nouveau trois portes. J'attend que tu me dise ou aller.",
		"Rep1": 14,     # mauvaise
		"Rep2": 14,     # mauvaise
		"Rep3": 18      # correcte
	},
	18: {
		"text": "Ok je vais encore à droite...
		\n C'est bon je vois trois nouvelles portes, dis moi laquelle prendre. ",
		"Rep1": 14,     # correcte
		"Rep2": 14,     # mauvaise
		"Rep3": 19      # mauvaise
	},
	19: {
		"text": "Trois fois droite, tu le fais au hasard ??
		\n Oublie ça a marché, t'assures ! Mais il reste des portes, j'attend la suite.",
		"Rep1": 20,     # correcte
		"Rep2": 14,     # mauvaise
		"Rep3": 14      # mauvaise
	},
	20: {
		"text": "Je vais à droite.
		\n Attend je crois qu'on a réussi, je vois plus de portes, juste un grand couloir...
		\n Je suis arrivé dans une salle circulaire. Au centre y'a un objet sur un piedestal. Une sorte de sphère et elle brille.
		Tu pense que je dois la prendre ?",
		"Rep1": 21
	},
	21: {
		"text": "Je vais la prendre pour l'étudier. Tant pis pour les conséquences.
		\n J'ai plus trop le choix y'a qu'un seul chemin ou aller le autres sont bloqués par des pierres...
		\n Je pensais pas voir ça ici mais les murs sont recouverts de fresques et de peintures perses, je me demande ou mène ce tunnel...",
		"Rep1": 22
	},
	22: {
		"text": "Je vois de la lumière je crois que j'arrive enfin au bout !
		\n On a réussi je suis sorti ! Mais par contre ma montre indique que je suis en Egypte... Comment ça se fait ??
		\n Bon c'est bizarre mais on se posera des questions plus tard d'abord on rentre fêter ça !",
	},
}

func _process(_delta: float) -> void:
	for node in get_tree().get_nodes_in_group("Bouttons"):
		if node.has_method("set_disabled"):
			node.set_disabled(texte_en_cours)

func afficher_texte_par_numero(numero: int) -> void:
	if dialogues.has(numero):

		if numero == 1:
			reponses_joueur.clear()
			code_correct = false

		if numero == 5:
			code_correct = reponses_joueur == [8, 4, 7, 6]
			reponses_joueur.clear()

		if numero == 6 or numero == 7 or numero == 8 or numero == 9:
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

		# Redirection dynamique pour texte 5 selon le code
		if numero == 5:
			if code_correct:
				data["Rep1"] = 8
			else:
				data["Rep1"] = 6

		var text = data.get("text", "")
		textebox.afficher(text, numero)
