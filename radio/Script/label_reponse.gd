extends Node

@onready var label_container := $Label
@onready var markers := [$Marker/M1, $Marker/M2, $Marker/M3]
@onready var label_reponse: Control = $"."

@onready var flecheG: Label = $FlecheG
@onready var flecheD: Label = $FlecheD

@onready var fleche_gauche: TextureButton = $Buttons/Fleche_gauche
@onready var fleche_droite: TextureButton = $Buttons/Fleche_droite
@onready var ok: TextureButton = $Buttons/ok

var labels: Array[Label] = []
var current_index := 0

func _ready():
	reset_labels()
	update_visible_labels()
	fleche_gauche.pressed.connect(_on_left_pressed)
	fleche_droite.pressed.connect(_on_right_pressed)
	ok.pressed.connect(_on_ok_pressed)



func reset_labels():
	labels.clear()
	current_index = 0
	
	var custom_font := preload("res://Assets/Fonts/Technology.ttf")
	
	for child in label_container.get_children():
		if child is Label:
			child.label_settings = LabelSettings.new()
			child.label_settings.font = custom_font
			child.label_settings.font_size = 25
			labels.append(child)
			child.visible = false
	
	if labels.size() == 0:
		push_error("Aucun label trouvé.")
		return


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
		Global.reponses_joueur.append(rep_index)
		Global.afficher_texte_par_numero(next_id)
		label_reponse.queue_free()
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
			label.label_settings.font_color = Color("#96E5DE")
		else:
			label.label_settings.font_color = Color("#35387A")

		label.queue_redraw()

	# Gérer visibilité des flèches
	if current_index == 0:
		flecheD.visible = true
		flecheG.visible = false
	elif current_index == labels.size() - 1:
		flecheD.visible = false
		flecheG.visible = true
	else:
		flecheD.visible = true
		flecheG.visible = true
