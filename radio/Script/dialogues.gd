extends Node

# Référence vers la scène Dialogues qui contient tous les AudioStreamPlayer
@onready var dialogues_scene = self  # Puisque le script est directement sur le nœud Dialogues

# Variable pour suivre le dernier texte joué (éviter les répétitions)
var last_played_text: int = -2  # Changé de -1 à -2 pour forcer la détection du premier dialogue

func _ready():
	print("=== AudioManager démarré ===")
	print("Nœud actuel: ", self.name)
	print("Global.current_text initial: ", Global.current_text)
	print("last_played_text initial: ", last_played_text)
	
	# Forcer une vérification immédiate
	call_deferred("force_check")

func _process(_delta):
	# Debug plus fréquent mais limité
	if Engine.get_process_frames() % 60 == 0:  # Une fois par seconde environ
		print("Current_text actuel: ", Global.current_text)
	
	# Vérifier si current_text a changé et jouer l'audio correspondant
	if Global.current_text != last_played_text:
		print("=== CHANGEMENT DÉTECTÉ ===")
		print("Ancien: ", last_played_text, " | Nouveau: ", Global.current_text)
		play_dialogue_audio(Global.current_text)
		last_played_text = Global.current_text

func play_dialogue_audio(text_number: int):
	print("=== TENTATIVE LECTURE DIALOGUE ===")
	print("Numéro demandé: ", text_number)
	
	# Vérifier que la scène Dialogues existe
	if not dialogues_scene:
		print("ERREUR: dialogues_scene est null")
		return
	
	# Arrêter tous les autres dialogues en cours
	stop_all_dialogues()
	
	# Chercher l'AudioStreamPlayer correspondant au numéro de texte
	var audio_player_name = "Dialogue" + str(text_number)
	print("Recherche de: ", audio_player_name)
	
	# Debug: lister tous les enfants
	print("Enfants disponibles:")
	for child in dialogues_scene.get_children():
		print("  - ", child.name)
	
	var audio_player = dialogues_scene.get_node_or_null(audio_player_name)
	
	if audio_player:
		print("✓ AudioPlayer trouvé: ", audio_player.name)
		print("✓ Type: ", audio_player.get_class())
		
		if audio_player is AudioStreamPlayer2D or audio_player is AudioStreamPlayer:
			print("✓ C'est bien un AudioStreamPlayer (2D ou normal)")
			
			if audio_player.stream:
				print("✓ Stream audio présent: ", audio_player.stream.resource_path)
				print("-> LECTURE EN COURS...")
				audio_player.play()
				
				# Vérifier si ça joue vraiment
				await get_tree().process_frame
				print("-> Est en train de jouer: ", audio_player.playing)
			else:
				print("✗ ERREUR: Pas de stream audio assigné")
		else:
			print("✗ ERREUR: Le nœud n'est pas un AudioStreamPlayer compatible")
	else:
		print("✗ ERREUR: AudioStreamPlayer non trouvé: ", audio_player_name)
	
	print("=== FIN TENTATIVE LECTURE ===")

# Fonction pour forcer une vérification
func force_check():
	print("=== FORCE CHECK ===")
	print("Global.current_text: ", Global.current_text)
	print("last_played_text: ", last_played_text)
	print("Différent? ", Global.current_text != last_played_text)
	
	if Global.current_text != last_played_text:
		print("Lancement forcé du dialogue ", Global.current_text)
		play_dialogue_audio(Global.current_text)
		last_played_text = Global.current_text

func stop_all_dialogues():
	# Arrêter tous les AudioStreamPlayer dans la scène Dialogues
	for child in dialogues_scene.get_children():
		if (child is AudioStreamPlayer or child is AudioStreamPlayer2D) and child.is_playing():
			child.stop()

# Fonction alternative si vous préférez déclencher manuellement
func trigger_dialogue(text_number: int):
	play_dialogue_audio(text_number)

# Fonction pour mettre en pause tous les dialogues
func pause_all_dialogues():
	for child in dialogues_scene.get_children():
		if (child is AudioStreamPlayer or child is AudioStreamPlayer2D) and child.is_playing():
			child.stream_paused = true

# Fonction pour reprendre tous les dialogues en pause
func resume_all_dialogues():
	for child in dialogues_scene.get_children():
		if child is AudioStreamPlayer or child is AudioStreamPlayer2D:
			child.stream_paused = false
