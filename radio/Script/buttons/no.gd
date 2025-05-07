extends TextureButton

# Taille normale du bouton
var original_scale := Vector2.ONE * 0.47
var reduced_scale := Vector2(0.95, 0.95) * 0.47 # Taille réduite à 90%
var reset_delay := 0.1  # Temps avant de remettre la taille normale

func _ready() -> void:
	original_scale = scale
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	scale = reduced_scale
	await get_tree().create_timer(reset_delay).timeout
	scale = original_scale
