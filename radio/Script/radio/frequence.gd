extends Control

@onready var slider := $"../Radio/HSlider"
@onready var dizaine := $Dizaine
@onready var unite := $unité
@onready var dixieme := $dixieme
@onready var diode_rouge: Sprite2D = $"../DiodeRouge"
@onready var diode_verte: Sprite2D = $"../DiodeVerte"
@onready var audio_1 = $Audio_1
@onready var plus_button:= $"../Radio/plus"
@onready var minus_button:= $"../Radio/moins"
@onready var gresillement_player: AudioStreamPlayer2D = $"../GresillementPlayer"

# Nouveaux AudioStreamPlayer pour les différentes fréquences
@onready var audio_station_1: AudioStreamPlayer2D = $AudioStation1
@onready var audio_station_2: AudioStreamPlayer2D = $AudioStation2
@onready var audio_station_3: AudioStreamPlayer2D = $AudioStation3
@onready var audio_station_4: AudioStreamPlayer2D = $AudioStation4
@onready var audio_station_5: AudioStreamPlayer2D = $AudioStation5
@onready var audio_station_6: AudioStreamPlayer2D = $AudioStation6
@onready var audio_station_7: AudioStreamPlayer2D = $AudioStation7
@onready var audio_station_8: AudioStreamPlayer2D = $AudioStation8
@onready var audio_station_9: AudioStreamPlayer2D = $AudioStation9

var timer := 0.0
var tracking := false
var current_audio_station: AudioStreamPlayer2D = null

# Paramètres pour modification du nœud Frequence
const POSITION_CIBLE := Vector2(0, -245)
const SCALE_CIBLE := Vector2(0.5, 0.5)
const FREQUENCE_CIBLE := 63.3
const MARGE := 0.05

# Configuration des stations radio (fréquence : AudioStreamPlayer)
var stations_radio := {
	1.6: null,
	18.2: null,
	24.7: null,
	33.3: null,
	49.3: null,
	56.1: null,
	77.4: null,
	82.6: null,
	98.7: null,
}

# Volume original du grésillement
var gresillement_volume_original: float

func _ready():
	# Assigner les AudioStreamPlayer aux stations et activer la lecture en boucle
	stations_radio[1.6] = audio_station_1
	stations_radio[18.2] = audio_station_2
	stations_radio[24.7] = audio_station_3
	stations_radio[33.3] = audio_station_4
	stations_radio[49.3] = audio_station_5
	stations_radio[56.1] = audio_station_6
	stations_radio[77.4] = audio_station_7
	stations_radio[82.6] = audio_station_8
	stations_radio[98.7] = audio_station_9

	# Configurer toutes les stations pour jouer en boucle
	for station in stations_radio.values():
		if station != null:
			station.autoplay = false  # On ne veut pas qu'elles démarrent automatiquement
			# Note: Si tu utilises des AudioStream qui supportent loop, assure-toi qu'ils sont configurés
	
	# Sauvegarder le volume original du grésillement
	gresillement_volume_original = gresillement_player.volume_db
	
	slider.value_changed.connect(_on_slider_value_changed)
	_on_slider_value_changed(slider.value)
	diode_rouge.visible = true
	diode_verte.visible = false

func _on_slider_value_changed(value: float) -> void:
	var int_part := int(value)
	var frac_part := int((value - int_part) * 10.0)
	
	dizaine.text = str((int_part / 10) % 10)
	unite.text = str(int_part % 10)
	dixieme.text = str(frac_part)
	
	# Vérifier si on est sur une station radio
	check_radio_stations(value)

func check_radio_stations(frequence: float) -> void:
	var station_trouvee: AudioStreamPlayer2D = null
	var marge_station := 0.3  # Marge pour capter une station
	
	# Chercher si on est proche d'une station
	for freq in stations_radio.keys():
		if abs(frequence - freq) <= marge_station:
			station_trouvee = stations_radio[freq]
			break
	
	# Gérer le changement de station
	if station_trouvee != current_audio_station:
		# Arrêter l'ancienne station
		if current_audio_station != null:
			current_audio_station.stop()
		
		# Démarrer la nouvelle station et baisser le grésillement
		if station_trouvee != null:
			current_audio_station = station_trouvee
			# S'assurer que la station joue en boucle avant de la démarrer
			setup_loop_for_station(current_audio_station)
			current_audio_station.play()
			# Baisser le volume du grésillement
			var tween = create_tween()
			tween.tween_property(gresillement_player, "volume_db", gresillement_volume_original - 15, 0.5)
		else:
			# Aucune station, remonter le grésillement
			current_audio_station = null
			var tween = create_tween()
			tween.tween_property(gresillement_player, "volume_db", gresillement_volume_original, 0.5)

func _process(delta: float) -> void:
	Global.Frequence = slider.value
	
	if abs(Global.Frequence - FREQUENCE_CIBLE) < MARGE:
		if not tracking and not Global.ok:
			tracking = true
			timer = 0.0
		elif not Global.ok:
			timer += delta
			if timer >= 1.0:
				# Arrêter toutes les stations avant de désactiver
				stop_all_stations()
				
				slider.editable = false
				plus_button.disabled = true
				minus_button.disabled = true
				
				Global.slider_modifiable = false
				Global.ok = true
				
				position = POSITION_CIBLE
				scale = SCALE_CIBLE
				diode_rouge.visible = false
				diode_verte.visible = true
				gresillement_player.stop()
	else:
		diode_rouge.visible = true
		diode_verte.visible = false
		tracking = false
		timer = 0.0

func stop_all_stations() -> void:
	for station in stations_radio.values():
		if station != null and station.playing:
			station.stop()
	current_audio_station = null

func setup_loop_for_station(station: AudioStreamPlayer2D) -> void:
	# Connecter le signal finished pour relancer la lecture
	if not station.finished.is_connected(_on_station_finished):
		station.finished.connect(_on_station_finished.bind(station))

func _on_station_finished(station: AudioStreamPlayer2D) -> void:
	# Relancer la station si elle est toujours la station active
	if station == current_audio_station:
		station.play()
