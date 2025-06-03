extends Control
@onready var pause_menu: Control = $".."
@onready var fleche_haut: TextureButton = $"../Buttons/Fleche_gauche"
@onready var fleche_bas: TextureButton = $"../Buttons/Fleche_droite"
@onready var choix: ColorRect = $Choix
@onready var label_quit: Label = $Quit
@onready var label_resume: Label = $Resume
@onready var click: AudioStreamPlayer2D = $"../Click"
@onready var ok = $"../Buttons/ok"

const MAIN_MENU = preload("res://Scene/main_menu.tscn")

var preloaded_main_menu: PackedScene = null

var current_selection := "resume"  # "resume" ou "quit"
# Marge à ajouter autour du label (en pixels)
var margin := Vector2(10, 5)  # Ajuste selon tes préférences

func _ready() -> void:
		# Ajoutez cette vérification
	print("MAIN_MENU chargé: ", MAIN_MENU)
	if MAIN_MENU == null:
		print("ERREUR: main_menu.tscn non trouvé !")
	
	fleche_haut.disabled = true
	fleche_bas.disabled = true
	current_selection = "resume"
	
	# Initialiser les LabelSettings pour chaque label
	label_resume.label_settings = LabelSettings.new()
	label_quit.label_settings = LabelSettings.new()

	ResourceLoader.load_threaded_request("res://Scene/main_menu.tscn")
	
	update_selection()

func _process(_delta):
	if Global.is_pausing:
		fleche_haut.disabled = false
		fleche_bas.disabled = false
		ok.disabled = false
	else:
		fleche_haut.disabled = true
		fleche_bas.disabled = true
		ok.disabled = true

func _on_fleche_gauche_pressed() -> void:
	click.play()
	current_selection = "resume"
	update_selection()

func _on_fleche_droite_pressed() -> void:
	click.play()
	current_selection = "quit"
	update_selection()

func update_selection():
	var selected_label: Label = null
	
	# Déterminer quel label est sélectionné et changer les couleurs de font
	if current_selection == "resume":
		selected_label = label_resume
		# Couleurs de font comme dans l'autre script
		label_resume.label_settings.font_color = Color("#96E5DE")  # Couleur de sélection
		label_quit.label_settings.font_color = Color("#35387A")    # Couleur normale
	elif current_selection == "quit":
		selected_label = label_quit
		# Couleurs de font comme dans l'autre script
		label_quit.label_settings.font_color = Color("#96E5DE")    # Couleur de sélection
		label_resume.label_settings.font_color = Color("#35387A")  # Couleur normale
	
	# Forcer le redessin des labels
	label_resume.queue_redraw()
	label_quit.queue_redraw()
	
	# Attendre que le label soit correctement dimensionné
	await get_tree().process_frame
	
	if selected_label:
		# Calculer la nouvelle taille avec marge
		var new_size = selected_label.size + margin * 2
		
		# Calculer la nouvelle position pour centrer le ColorRect
		var new_position = selected_label.global_position - margin
		
		choix.global_position = new_position
		choix.size = new_size
		choix.visible = true

func _on_ok_pressed() -> void:
	click.play()
	
	if current_selection == "resume":
		# Reprendre le jeu
		Global.is_pausing = false
		get_tree().paused = false
		await get_tree().process_frame
		pause_menu.queue_free()
		
	elif current_selection == "quit":
		print("Début du quit")
		Global.is_pausing = false
		get_tree().paused = false
		
		var tree = get_tree()
		
		print("Démarrage transition")
		TransitionScreen.transition()
		await TransitionScreen.on_transition_finished
		print("Transition terminée")
		
		# Récupérer la scène préchargée
		if preloaded_main_menu == null:
			preloaded_main_menu = ResourceLoader.load_threaded_get("res://Scene/main_menu.tscn")
		
		print("Changement de scène avec préchargement")
		var error = tree.change_scene_to_packed(preloaded_main_menu)
		print("Résultat: ", error)
		pause_menu.queue_free()
