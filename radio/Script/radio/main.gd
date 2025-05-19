extends Node2D

@onready var slider: HSlider = $Radio/HSlider
@onready var yes: TextureButton = $Bouttons/Yes
@onready var no: TextureButton = $Bouttons/No

var current_scene: Node = null

@onready var textebox = get_node("/root/Main/Textebox")  # adapte le chemin

func _ready():
	Global.ok = false
	yes.disabled = true
	no.disabled = true
	update_value(slider.value)
	slider.value_changed.connect(update_value)

	textebox.connect("texte_termine", Callable(self, "on_texte_termine"))

func update_value(value: float) -> void:
	Global.Frequence = slider.value

func on_texte_termine() -> void:
	instantiate_scene_for_text(Global.current_text)

func instantiate_scene_for_text(text_id: int) -> void:
	if current_scene:
		current_scene.queue_free()

	if text_id <= 0:
		return  # Pas de scène pour texte 0 ou négatif

	var scene_path := "res://Scene/%d.tscn" % text_id
	if ResourceLoader.exists(scene_path):
		var packed_scene := load(scene_path)
		current_scene = packed_scene.instantiate()
		add_child(current_scene)
	else:
		push_warning("Aucune scène trouvée pour le texte #%d à %s" % [text_id, scene_path])

func _process(delta: float) -> void:
	if Global.is_pausing == true:
		get_tree().paused = true
	else:
		get_tree().paused = false
	
