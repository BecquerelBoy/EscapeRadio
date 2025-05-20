extends Control

@onready var pause_menu: Control = $".."
@onready var fleche_haut: TextureButton = $"../Pause_buttons/Fleche_haut"
@onready var fleche_bas: TextureButton = $"../Pause_buttons/Fleche_bas"
@onready var quit_select: Sprite2D = $quit_select
@onready var resume_select: Sprite2D = $resume_select
@onready var click: AudioStreamPlayer2D = $"../Click"
@onready var ok = $"../Pause_buttons/ok"

func _ready() -> void:
	fleche_haut.disabled = true
	fleche_bas.disabled = true
	resume_select.visible = true

func _process(_delta):
	if Global.is_pausing:
		fleche_haut.disabled = false
		fleche_bas.disabled = false
		ok.disabled = false
	else:
		fleche_haut.disabled = true
		fleche_bas.disabled = true
		ok.disabled = true

func _on_fleche_haut_pressed() -> void:
	click.play()
	resume_select.visible = true
	quit_select.visible = false

func _on_fleche_bas_pressed() -> void:
	click.play()
	resume_select.visible = false
	quit_select.visible = true

func _on_ok_pressed() -> void:
	click.play()
	
	if resume_select.visible:
		Global.is_pausing = false
		get_tree().paused = false  # 1. Dépauser le jeu
		await get_tree().process_frame  # 2. Laisser Godot actualiser l'état
		pause_menu.queue_free()        # 3. Supprimer la scène pause
		
	elif quit_select.visible:
		Global.is_pausing = false
		get_tree().paused = false
		pause_menu.queue_free()        # 3. Supprimer la scène pause
		get_tree().change_scene_to_file("res://Scene/main_menu.tscn")
