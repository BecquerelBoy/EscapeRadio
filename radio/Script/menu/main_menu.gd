extends Control

@onready var lampe_a_huile: AnimatedSprite2D = $lampe_a_huile
@onready var musique: AudioStreamPlayer2D = $music
@onready var titre: AnimatedSprite2D = $titre

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	lampe_a_huile.play()
	
	# Lancer l'animation du titre avec un délai
	start_titre_animation()
	
	# Configurer la musique en boucle et la jouer
	if musique.stream:
		musique.stream.loop = true
	musique.play()

func start_titre_animation() -> void:
	# Attendre 0.5 seconde avant de lancer l'animation du titre
	await get_tree().create_timer(0.5).timeout
	
	# Configurer le titre pour ne jouer qu'une fois
	titre.sprite_frames.set_animation_loop("default", false)
	titre.play()
