extends Node
@onready var label_container := $Label
@onready var markers := [$Marker/M1, $Marker/M2, $Marker/M3, $Marker/M4, $Marker/M5]
@onready var label_reponse: Control = $"."
@onready var flecheG: Label = $FlecheG
@onready var flecheD: Label = $FlecheD
@onready var fleche_gauche: TextureButton = $Buttons/Fleche_gauche
@onready var fleche_droite: TextureButton = $Buttons/Fleche_droite
@onready var ok: TextureButton = $Buttons/ok
@onready var color_rect: ColorRect = $ColorRect

var labels: Array[Label] = []
var current_index := 0

# Marge à ajouter autour du label (en pixels)
var margin := Vector2(10, 10)  # 10px horizontal, 5px vertical

func _ready():
	reset_labels()
	update_visible_labels()
	fleche_gauche.pressed.connect(_on_left_pressed)
	fleche_droite.pressed.connect(_on_right_pressed)
	ok.pressed.connect(_on_ok_pressed)

func reset_labels():
	labels.clear()
	current_index = 0
	for child in label_container.get_children():
		if child is Label:
			child.label_settings = LabelSettings.new()
			labels.append(child)
			child.visible = false
	if labels.is_empty():
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
	var central_index = current_index
	if central_index < 0 or central_index >= labels.size():
		push_error("Index central hors limites.")
		return
	var label_central = labels[central_index]
	var rep_index = int(str(label_central.name))
	var current_id = Global.current_text
	var current_data = Global.dialogues.get(current_id, {})
	var rep_key = "Rep" + str(rep_index)
	if current_data.has(rep_key):
		var next_id = current_data[rep_key]
		if typeof(next_id) == TYPE_STRING:
			Global.traiter_choix_direction(next_id)
		else:
			Global.reponses_joueur.append(rep_index)
			Global.afficher_texte_par_numero(next_id)
		label_reponse.queue_free()
	else:
		push_error("Réponse non trouvée : " + rep_key + " pour le dialogue " + str(current_id))

func update_visible_labels():
	for label in labels:
		label.visible = false
	
	# Cacher le ColorRect par défaut
	color_rect.visible = false
	
	var selected_label: Label = null
	
	for i in range(5):
		var label_index = current_index + i - 2
		if label_index < 0 or label_index >= labels.size():
			continue
		var label = labels[label_index]
		if not is_instance_valid(label):
			continue
		if i >= markers.size() or not is_instance_valid(markers[i]):
			continue
		
		label.global_position = markers[i].global_position
		label.visible = true
		
		if i == 2:  # Label central (sélectionné)
			label.label_settings.font_color = Color("#96E5DE")
			selected_label = label
		else:
			label.label_settings.font_color = Color("#35387A")
		
		label.queue_redraw()
	
	# Ajuster le ColorRect après avoir traité tous les labels
	if selected_label:
		# Attendre que le label soit correctement dimensionné
		await get_tree().process_frame
		
		# Utiliser get_minimum_size() pour une taille plus précise
		var text_size = selected_label.get_minimum_size()

		# Ajouter une petite marge manuelle autour
		var new_size = text_size + margin * 2

		# Recalculer la position de manière plus fiable
		var new_position = selected_label.global_position - margin
		
		color_rect.global_position = new_position
		color_rect.size = new_size
		color_rect.visible = true
	
	# Visibilité des flèches
	var total_labels := labels.size()
	flecheG.visible = current_index > 0
	flecheD.visible = current_index < total_labels - 1
