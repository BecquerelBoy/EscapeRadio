extends VSlider

func _ready() -> void:
	update_cursor()
	
	# Connecter les signaux de survol
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _process(_delta: float) -> void:
	update_cursor()

func update_cursor() -> void:
	if Global.slider_modifiable == false:
		mouse_default_cursor_shape = Control.CURSOR_ARROW
	else:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _on_mouse_entered() -> void:
	if Global.slider_modifiable:
		# Éclaircir le grabber via le thème ou shader
		if get_theme_stylebox("grabber", "VSlider"):
			var grabber_style = get_theme_stylebox("grabber", "VSlider")
			if grabber_style.has_method("set_shader_parameter"):
				grabber_style.set_shader_parameter("is_hovered", true)
		
		# Alternative : modifier la modulation du grabber
		_set_grabber_brightness(true)

func _on_mouse_exited() -> void:
	# Remettre la couleur normale du grabber
	if get_theme_stylebox("grabber", "VSlider"):
		var grabber_style = get_theme_stylebox("grabber", "VSlider")
		if grabber_style.has_method("set_shader_parameter"):
			grabber_style.set_shader_parameter("is_hovered", false)
	
	# Alternative : remettre la modulation normale
	_set_grabber_brightness(false)

func _set_grabber_brightness(is_bright: bool) -> void:
	# Méthode alternative utilisant la modulation
	if is_bright:
		modulate = Color(1.3, 1.3, 1.3, 1.0)  # Plus clair
	else:
		modulate = Color.WHITE  # Normal
