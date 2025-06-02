extends Node2D

@onready var slider: VSlider = $Radio/HSlider
@onready var yes: TextureButton = $Bouttons/Yes
@onready var no: TextureButton = $Bouttons/No
@onready var frequence: Control = $Frequence
@onready var plus_button: Button = $Radio/plus
@onready var minus_button: Button = $Radio/moins

var current_scene: Node = null
@onready var textebox = get_node("/root/Main/Textebox")  # adapte le chemin

func _ready():
	Global.ok = false
	yes.disabled = true
	no.disabled = true
	update_value(slider.value)
	slider.value_changed.connect(update_value)
	textebox.connect("texte_termine", Callable(self, "on_texte_termine"))
	
	# Connexion des boutons plus et moins
	plus_button.pressed.connect(_on_plus_pressed)
	minus_button.pressed.connect(_on_minus_pressed)

func _on_plus_pressed():
	var new_value = slider.value + 0.1
	slider.value = clamp(new_value, slider.min_value, slider.max_value)

func _on_minus_pressed():
	var new_value = slider.value - 0.1
	slider.value = clamp(new_value, slider.min_value, slider.max_value)

func update_value(value: float) -> void:
	Global.Frequence = slider.value

func on_texte_termine() -> void:
	instantiate_scene_for_text(Global.current_text)

func instantiate_scene_for_text(text_id: int) -> void:
	if text_id <= 0:
		return  # Pas de scène pour texte 0 ou négatif
	
	var scene_path := "res://Scene/choix/%d.tscn" % text_id
	if ResourceLoader.exists(scene_path):
		var packed_scene := load(scene_path)
		current_scene = packed_scene.instantiate()
		add_child(current_scene)
	else:
		push_warning("Aucune scène trouvée pour le texte #%d à %s" % [text_id, scene_path])

func _process(_delta: float) -> void:
	if Global.is_pausing == true:
		get_tree().paused = true
	else:
		get_tree().paused = false
	
	# Gestionnaire de curseur global
	manage_cursor()

func manage_cursor():
	var mouse_pos = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = mouse_pos
	query.collision_mask = 0xFFFFFFFF
	query.collide_with_areas = true
	
	var results = space_state.intersect_point(query)
	var should_be_pointing = false
	
	for result in results:
		var collider = result.collider
		if collider.is_in_group("clickable_elements"):
			should_be_pointing = true
			break
	
	if should_be_pointing:
		Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	else:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
