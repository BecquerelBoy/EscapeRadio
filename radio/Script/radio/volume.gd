extends VSlider

@export var bus_name: String
var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	
	if bus_index == -1:
		push_error("Le bus audio '" + bus_name + "' n'existe pas.")
		return
	
	value_changed.connect(_on_value_changed)
	
	# Connecter les signaux de survol
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

@warning_ignore("shadowed_variable_base_class")
func _on_value_changed(value: float) -> void:
	if bus_index != -1:
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(value)
		)

func _on_mouse_entered() -> void:
	# Changer le curseur en main pointée
	mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
	
	# Éclaircir le grabber via le thème ou shader
	if get_theme_stylebox("grabber", "VSlider"):
		var grabber_style = get_theme_stylebox("grabber", "VSlider")
		if grabber_style.has_method("set_shader_parameter"):
			grabber_style.set_shader_parameter("is_hovered", true)
	
	# Alternative : modifier la modulation du grabber si accessible
	_set_grabber_brightness(true)

func _on_mouse_exited() -> void:
	# Remettre le curseur normal
	mouse_default_cursor_shape = Control.CURSOR_ARROW
	
	# Remettre la couleur normale du grabber
	if get_theme_stylebox("grabber", "VSlider"):
		var grabber_style = get_theme_stylebox("grabber", "VSlider")
		if grabber_style.has_method("set_shader_parameter"):
			grabber_style.set_shader_parameter("is_hovered", false)
	
	# Alternative : remettre la modulation normale
	_set_grabber_brightness(false)

func _set_grabber_brightness(is_bright: bool) -> void:
	# Méthode alternative utilisant la modulation
	# Cette approche fonctionne si le grabber est une texture
	if is_bright:
		modulate = Color(1.3, 1.3, 1.3, 1.0)  # Plus clair
	else:
		modulate = Color.WHITE  # Normal
