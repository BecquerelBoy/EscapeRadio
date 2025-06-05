extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Connecter le signal pressed du bouton à la fonction de changement de scène
	pressed.connect(_on_button_pressed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# Fonction appelée quand le bouton est pressé
func _on_button_pressed() -> void:
	# Charger la scène "fin"
	TransitionScreen.transition()
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_file("res://Scene/fin.tscn")
