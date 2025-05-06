extends Control

@onready var text: Label = $MarginContainer/VBoxContainer/Text
@onready var scroll: ScrollContainer = $MarginContainer

var full_text := ""
var current_index := 0
var letter_delay := 0.05
var timer := 0.0
var displaying := false
var texte_deja_lance := false  # Pour éviter de redémarrer le texte à chaque frame

func _process(delta: float) -> void:
	if Global.ok and not texte_deja_lance:
		full_text = Global.textes[1]
		afficher(Global.textes[1])
		texte_deja_lance = true

	if displaying:
		timer += delta
		if timer >= letter_delay and current_index < full_text.length():
			text.text += full_text[current_index]
			current_index += 1
			timer = 0.0

			await get_tree().process_frame  # Attente de la mise à jour du texte
			scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value

func afficher(nouveau_texte: String) -> void:
	full_text = nouveau_texte
	text.text = ""
	current_index = 0
	timer = 0.0
	displaying = true
