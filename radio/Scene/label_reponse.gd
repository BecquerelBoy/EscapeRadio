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
			KEY_RIGHT:
				current_index = (current_index + 1) % labels.size()
				update_visible_labels()
			KEY_LEFT:
				current_index = (current_index - 1 + labels.size()) % labels.size()
				update_visible_labels()

func update_visible_labels():
	# Cache tous les labels
	for label in labels:
		label.visible = false

	for i in range(3):
		var label_index = (current_index + i - 1 + labels.size()) % labels.size()
		var label = labels[label_index]
		label.global_position = markers[i].global_position
		label.visible = true
