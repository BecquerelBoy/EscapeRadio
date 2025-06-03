extends Area2D

# Variables pour contrôler la vitesse des animations
@export var scale_speed: float = 2.0  # Vitesse du grossissement
@export var scale_factor: float = 1.2  # Facteur de grossissement (1.2 = 20% plus grand)
@export var scale_curve: Curve  # Courbe pour l'animation d'échelle
@export var click_curve: Curve  # Courbe pour l'animation de clic (enfoncement)
@export var click_speed: float = 8.0  # Vitesse de l'animation de clic
@export var click_scale: float = 0.9  # Facteur d'enfoncement (0.9 = 10% plus petit)

# Références aux nœuds
@onready var animated_sprite = $AnimatedSprite2D
@onready var blip: AudioStreamPlayer2D = $"../blip"

const MAIN = preload("res://Scene/Main.tscn")

# Tweens pour les animations
var scale_tween: Tween
var click_tween: Tween
var is_hovering: bool = false
var animation_playing: bool = false
var clicking: bool = false

func _ready():
	# Connecter seulement mouse_entered/exited
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	# Ne pas connecter input_event
	
	setup_initial_state()

# Remplacer _on_input_event par :
func _unhandled_input(event):
	if not is_hovering:
		return
		
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start_click_animation()
			get_viewport().set_input_as_handled()

func setup_initial_state():
	# S'assurer que l'animation ne boucle pas
	if animated_sprite.sprite_frames:
		animated_sprite.sprite_frames.set_animation_loop("default", false)
	
	# Aller à la première frame
	animated_sprite.frame = 0
	animated_sprite.stop()
	
	# Échelle normale
	scale = Vector2.ONE
	
	# Curseur normal
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

func _on_mouse_entered():
	print("Mouse entered - DEBUG")  # Ajoutez cette ligne
	is_hovering = true
	blip.play(0.3)
	# Changer le curseur en main pointée
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	
	if not animation_playing and not clicking:
		start_hover_animation()
	elif not clicking:
		# Si l'animation est en cours, juste grossir
		scale_up()

func _on_mouse_exited():
	is_hovering = false
	blip.stop()
	# Remettre le curseur normal
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	
	# Ne pas interrompre si on est en train de cliquer
	if clicking:
		return
	
	# Revenir instantanément à la première frame
	animated_sprite.frame = 0
	animated_sprite.stop()
	animation_playing = false
	
	# Rapetisser le bouton
	scale_down()

func _on_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# Clic pressé - déclencher l'animation d'enfoncement
			start_click_animation()
		# Note: On ne gère pas le relâchement ici car l'animation se gère toute seule

func start_click_animation():
	if clicking:
		return  # Éviter les clics multiples
	
	clicking = true
	
	# Créer l'animation d'enfoncement
	if click_tween:
		click_tween.kill()
	
	click_tween = create_tween()
	click_tween.set_ease(Tween.EASE_OUT)
	click_tween.set_trans(Tween.TRANS_BACK)
	
	# Utiliser la courbe de clic personnalisée
	if click_curve:
		click_tween.tween_method(_apply_click_curve, 0.0, 1.0, 1.0 / click_speed)
	else:
		# Animation d'enfoncement simple
		var tween_sequence = click_tween.tween_property(self, "scale", Vector2.ONE * click_scale, 0.1)
		tween_sequence.tween_property(self, "scale", Vector2.ONE * scale_factor if is_hovering else Vector2.ONE, 0.1)
	
	# Attendre la fin de l'animation de clic
	await click_tween.finished
	
	clicking = false
	
	# Charger la scène Main
	load_main_scene()

func _apply_click_curve(progress: float):
	var curve_value = click_curve.sample(progress)
	var base_scale = scale_factor if is_hovering else 1.0
	var click_offset = (base_scale - click_scale) * curve_value
	var target_scale = base_scale - click_offset
	scale = Vector2.ONE * target_scale


func load_main_scene():
	# Lancer la transition et le fade out de la musique simultanément
	TransitionScreen.transition()
	MusicManager.stop_music(0.4)  # Durée du fade out (ajustez selon la durée de votre transition)
	
	await TransitionScreen.on_transition_finished
	get_tree().change_scene_to_packed(MAIN) # Ajustez le chemin selon votre projet

func start_hover_animation():
	animation_playing = true
	
	# Lancer l'animation du sprite (une seule fois)
	animated_sprite.play()
	
	# Grossir le bouton
	scale_up()
	
	# Attendre la fin de l'animation
	await animated_sprite.animation_finished
	
	animation_playing = false

func scale_up():
	# Créer un nouveau Tween pour le grossissement
	if scale_tween:
		scale_tween.kill()
	
	scale_tween = create_tween()
	scale_tween.set_ease(Tween.EASE_OUT)
	scale_tween.set_trans(Tween.TRANS_BACK)
	
	# Utiliser la courbe personnalisée si disponible
	if scale_curve:
		scale_tween.tween_method(_apply_scale_curve, 0.0, 1.0, 1.0 / scale_speed)
	else:
		# Animation d'échelle classique
		scale_tween.tween_property(self, "scale", Vector2.ONE * scale_factor, 1.0 / scale_speed)

func scale_down():
	# Créer un nouveau Tween pour rapetisser
	if scale_tween:
		scale_tween.kill()
	
	scale_tween = create_tween()
	scale_tween.set_ease(Tween.EASE_OUT)
	scale_tween.set_trans(Tween.TRANS_BACK)
	
	# Utiliser la courbe personnalisée si disponible
	if scale_curve:
		scale_tween.tween_method(_apply_scale_curve_reverse, 0.0, 1.0, 1.0 / scale_speed)
	else:
		# Animation d'échelle classique
		scale_tween.tween_property(self, "scale", Vector2.ONE, 1.0 / scale_speed)

func _apply_scale_curve(progress: float):
	# Appliquer la courbe pour grossir
	var curve_value = scale_curve.sample(progress)
	var target_scale = 1.0 + (scale_factor - 1.0) * curve_value
	scale = Vector2.ONE * target_scale

func _apply_scale_curve_reverse(progress: float):
	# Appliquer la courbe pour rapetisser (inversée)
	var _curve_value = scale_curve.sample(1.0 - progress)
	var current_scale = scale.x  # Prendre l'échelle actuelle
	var target_scale = current_scale - (current_scale - 1.0) * progress
	scale = Vector2.ONE * target_scale

# Fonction publique pour déclencher l'animation manuellement si besoin
func trigger_animation():
	if not animation_playing:
		start_hover_animation()
