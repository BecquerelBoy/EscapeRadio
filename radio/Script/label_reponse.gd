extends Node

@onready var label_container := $Label
@onready var markers := [$Marker/M1, $Marker/M2, $Marker/M3]

var labels: Array[Label] = []
var current_index := 0

func _ready():
	
	var custom_font := preload("res://Assets/Fonts/Technology.ttf")  # chemin vers ta police
	
	for child in label_container.get_children():
		if child is Label:
			child.label_settings = LabelSettings.new()
			child.label_settings.font = custom_font
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
			label.label_settings.font_color = Color("#96E5DE")  # label sélectionné
		else:
			label.label_settings.font_color = Color("#35387A")  # autres

			
		label.queue_redraw()
