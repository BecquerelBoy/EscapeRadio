extends TextureButton

@onready var click: AudioStreamPlayer2D = $"../../Click"

# Taille normale du bouton
var original_scale := Vector2.ONE * 0.2
var reduced_scale := Vector2(0.97, 0.97) * 0.2 # Taille réduite à 90%
var reset_delay := 0.1  # Temps avant de remettre la taille normale

func _ready() -> void:
	original_scale = scale
	update_cursor()
	
	# Connecter les signaux de survol
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_pressed() -> void:
	click.play()
	scale = reduced_scale
	await get_tree().create_timer(reset_delay).timeout
	scale = original_scale

func _process(_delta: float) -> void:
	update_cursor()

func update_cursor() -> void:
	if disabled:
		mouse_default_cursor_shape = Control.CURSOR_ARROW
	else:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _on_mouse_entered() -> void:
	if not disabled and material:
		material.set_shader_parameter("is_hovered", true)

func _on_mouse_exited() -> void:
	if material:
		material.set_shader_parameter("is_hovered", false)
