extends Control

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Restaurer le volume de la musique après un court délai
	await get_tree().create_timer(0.3).timeout
	MusicManager.restore_volume(0.8)
