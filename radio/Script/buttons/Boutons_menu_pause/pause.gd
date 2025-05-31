extends TextureButton

# Animation de mise à l’échelle
var original_scale := Vector2.ONE 
var reduced_scale := Vector2(0.95, 0.95) * 0.5
var reset_delay := 0.1

@onready var click: AudioStreamPlayer2D = $"../Click"

func _ready() -> void:
	original_scale = scale
	update_cursor()

func _on_pressed() -> void:
	scale = reduced_scale
	await get_tree().create_timer(reset_delay).timeout
	scale = original_scale
	click.play()

	var pause_scene_path = "res://Scene/pause_menu.tscn"

	if Global.is_pausing:
		# Si déjà en pause, on supprime la scène de pause
		var pause_menu = get_tree().root.get_node_or_null("pause_menu")
		if pause_menu:
			pause_menu.queue_free()
		Global.is_pausing = false
		get_tree().paused = false
	else:
		# Sinon on l’instancie
		if ResourceLoader.exists(pause_scene_path):
			var pause_scene = load(pause_scene_path).instantiate()
			pause_scene.name = "pause_menu"  # Important pour pouvoir la supprimer
			get_tree().root.add_child(pause_scene)
			Global.is_pausing = true
			get_tree().paused = true
		else:
			push_error("Impossible de trouver la scène pause_menu à " + pause_scene_path)

func _process(_delta: float) -> void:
	update_cursor()

func update_cursor() -> void:
	mouse_default_cursor_shape = Control.CURSOR_ARROW if disabled else Control.CURSOR_POINTING_HAND
