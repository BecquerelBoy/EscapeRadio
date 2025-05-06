extends Control

@onready var text: Label = $MarginContainer/VBoxContainer/Text
@onready var scroll: ScrollContainer = $MarginContainer

var full_text := ""
var current_index := 0
var letter_delay := 0.05
var timer = 0.0
var displaying = false
var texte_deja_lance = false

func _ready() -> void:
	Global.texte_en_cours = true

func _process(delta: float) -> void:
	if Global.ok and not texte_deja_lance:
		afficher(Global.textes[1], 1)
		texte_deja_lance = true

	if displaying:
		timer += delta
		if timer >= letter_delay and current_index < full_text.length():
			text.text += full_text[current_index]
			current_index += 1
			timer = 0.0

			await get_tree().process_frame
			scroll.scroll_vertical = scroll.get_v_scroll_bar().max_value

			if current_index == full_text.length():
				displaying = false
				Global.texte_en_cours = false

func afficher(nouveau_texte: String, numero: int) -> void:
	full_text = nouveau_texte
	Global.current_text = numero  # <-- Mise à jour du numéro de texte global
	text.text = ""
	current_index = 0
	timer = 0.0
	displaying = true
	Global.texte_en_cours = true
