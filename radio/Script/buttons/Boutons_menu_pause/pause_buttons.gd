extends Control

@onready var pause = $Pause
@onready var click = $"../Bouttons/Click"


func _on_pause_pressed() -> void:
	click.play()
	
	# Instanciation de la scène pause_menu
	var pause_scene_path = "res://pause_menu.tscn"
	if ResourceLoader.exists(pause_scene_path):
		var pause_scene = load(pause_scene_path).instantiate()
		# Ajoute la scène au niveau racine (ou à un nœud parent approprié)
		get_tree().root.add_child(pause_scene)
	else:
		push_error("Impossible de trouver la scène pause_menu à " + pause_scene_path)
	
	Global.is_pausing = true
	get_tree().paused = true
