extends TextureButton

# Animation de mise à l'échelle
var original_scale := Vector2.ONE 
var reduced_scale := Vector2(0.95, 0.95) * 0.5
var reset_delay := 0.1

# Préchargement de la scène de pause
const PAUSE_SCENE = preload("res://Scene/pause_menu.tscn")

@onready var click: AudioStreamPlayer2D = $"../Click"

func _ready() -> void:
	original_scale = scale
	update_cursor()
	
	# Connecter les signaux de survol
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_pressed() -> void:
	scale = reduced_scale
	await get_tree().create_timer(reset_delay).timeout
	scale = original_scale
	click.play()
	
	if Global.is_pausing:
		# Si déjà en pause, on supprime la scène de pause
		var pause_menu = get_tree().root.get_node_or_null("pause_menu")
		if pause_menu:
			pause_menu.queue_free()
		Global.is_pausing = false
		get_tree().paused = false
	else:
		# Instancier la scène préchargée
		var pause_scene = PAUSE_SCENE.instantiate()
		pause_scene.name = "pause_menu"  # Important pour pouvoir la supprimer
		get_tree().root.add_child(pause_scene)
		Global.is_pausing = true
		get_tree().paused = true

func _process(_delta: float) -> void:
	update_cursor()

func update_cursor() -> void:
	mouse_default_cursor_shape = Control.CURSOR_ARROW if disabled else Control.CURSOR_POINTING_HAND

func _on_mouse_entered() -> void:
	if not disabled and material:
		material.set_shader_parameter("is_hovered", true)

func _on_mouse_exited() -> void:
	if material:
		material.set_shader_parameter("is_hovered", false)
