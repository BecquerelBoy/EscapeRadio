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
	var dialogue_id = int(str(label_central.name))  # Le nom du label doit être un chiffre
	if Global.dialogues.has(dialogue_id):
		var texte = Global.dialogues[dialogue_id].get("text", "")
		print("Dialogue ID : ", dialogue_id, " → Texte : ", texte)
		Global.afficher_texte_par_numero(dialogue_id)

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
