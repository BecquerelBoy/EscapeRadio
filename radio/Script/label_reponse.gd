extends Node

@onready var label_container := $Control
@onready var markers := [
	$Control2/M1,
	$Control2/M2,
	$Control2/M3
]

var labels: Array[Label] = []
var current_index := 0  # index du label principal (centré sur Marker2)

func _ready():
	# Récupère tous les labels dans l'ordre
	for child in label_container.get_children():
		if child is Label:
			labels.append(child)
			child.visible = false

	if labels.size() == 0:
		push_error("Aucun label trouvé.")
		return

	update_visible_labels()

func _input(event):
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_LEFT:
				if current_index > 0:
					current_index -= 1
					update_visible_labels()
			KEY_RIGHT:
				if current_index < labels.size() - 1:
					current_index += 1
					update_visible_labels()

func update_visible_labels():
	# Cache tous les labels
	for label in labels:
		label.visible = false

	for i in range(3):
		var label_index = current_index + i - 1
		if label_index < 0 or label_index >= labels.size():
			continue  # Pas de label à afficher pour ce marker hors bornes

		var label = labels[label_index]
		label.global_position = markers[i].global_position
		label.visible = true

		if i == 1:
			label.set("theme_override_colors/font_color", Color("#96E5DE"))  # bleu clair
		else:
			label.set("theme_override_colors/font_color", Color("#35387A"))  # bleu foncé
