extends Node

@onready var label: Label = $Text
var full_text := "Voici le message que tu veux afficher progressivement."
var current_index := 0
var letter_delay := 0.05  # délai entre chaque lettre en secondes
var timer := 0.0
var displaying := false

func _process(delta: float) -> void:
	if Global.ok and not displaying:
		start_text_display()

	if displaying:
		timer += delta
		if timer >= letter_delay and current_index < full_text.length():
			label.text += full_text[current_index]
			current_index += 1
			timer = 0.0

func start_text_display() -> void:
	label.text = ""
	current_index = 0
	timer = 0.0
	displaying = true
