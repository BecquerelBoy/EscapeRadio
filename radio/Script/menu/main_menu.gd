extends Control
@onready var lampe_a_huile: AnimatedSprite2D = $lampe_a_huile
@onready var musique: AudioStreamPlayer2D = $music  # Gardez cette référence pour récupérer le stream
@onready var titre: AnimatedSprite2D = $titre

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	lampe_a_huile.play()

	await get_tree().create_timer(0.3).timeout
	MusicManager.restore_volume(0.8)
	
	# Lancer l'animation du titre avec un délai
	start_titre_animation()
	
	# Utiliser le MusicManager au lieu de l'AudioStreamPlayer2D local
	if musique.stream:
		MusicManager.play_music(musique.stream, 2.0)  # Fade in de 2 secondes

func start_titre_animation() -> void:
	# Attendre 0.5 seconde avant de lancer l'animation du titre
	await get_tree().create_timer(0.5).timeout
	
	# Configurer le titre pour ne jouer qu'une fois
	titre.sprite_frames.set_animation_loop("default", false)
	titre.play()
