extends Node

@onready var label_container := $Label
@onready var markers := [$Marker/M1, $Marker/M2, $Marker/M3]

var labels: Array[Label] = []
var current_index := 0

func _ready():
	# Récupérer tous les labels et les cacher
	for child in label_container.get_children():
		if child is Label:
			labels.append(child)
			child.visible = false

	if labels.size() == 0:
		push_error("Aucun label trouvé.")
		return

	update_visible_labels()

func _on_left_pressed() -> void:
	if current_index > 0:
		current_index -= 1
		update_visible_labels()

func _on_right_pressed() -> void:
	if current_index < labels.size() - 1:
		current_index += 1
		update_visible_labels()

func _on_ok_pressed() -> void:
	var label_central = labels[current_index]
	var rep_index = int(str(label_central.name))  # Le nom du label = numéro de réponse : 1, 2, 3, ...

	var current_id = Global.current_text
	var current_data = Global.dialogues.get(current_id, {})
	var rep_key = "Rep" + str(rep_index)

	if current_data.has(rep_key):
		var next_id = current_data[rep_key]
		Global.reponses_joueur.append(rep_index)  # Enregistrer la réponse
		Global.afficher_texte_par_numero(next_id)
	else:
		push_error("Réponse non trouvée : " + rep_key + " pour le dialogue " + str(current_id))


func update_visible_labels():
	for label in labels:
		label.visible = false

	for i in range(3):
		var label_index = current_index + i - 1
		if label_index < 0 or label_index >= labels.size():
			continue

		var label = labels[label_index]
		label.global_position = markers[i].global_position
		label.visible = true

		if i == 1:
			label.set("theme_override_colors/font_color", Color("#96E5DE"))
			print("Label central sélectionné : ", label.name)
		else:
			label.set("theme_override_colors/font_color", Color("#35387A"))
