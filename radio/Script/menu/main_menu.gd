extends Control

@onready var lampe_a_huile: AnimatedSprite2D = $lampe_a_huile
@onready var musique: AudioStreamPlayer2D = $music

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	lampe_a_huile.play()
	
	# Configurer la musique en boucle et la jouer
	if musique.stream:
		musique.stream.loop = true
	musique.play()
