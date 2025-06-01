extends Control

@onready var slider := $"../Radio/HSlider"
@onready var dizaine := $Dizaine
@onready var unite := $unité
@onready var dixieme := $dixieme
@onready var diode_rouge: Sprite2D = $"../DiodeRouge"
@onready var diode_verte: Sprite2D = $"../DiodeVerte"
@onready var audio_1 = $Audio_1
@onready var plus_button: Button = $"../Radio/plus"
@onready var minus_button: Button = $"../Radio/moins"  # Ajuste le chemin selon ta hiérarchie

var timer := 0.0
var tracking := false

# Paramètres pour modification du nœud Frequence
const POSITION_CIBLE := Vector2(0, -245)  # à ajuster
const SCALE_CIBLE := Vector2(0.5, 0.5)    # à ajuster
const FREQUENCE_CIBLE := 1.6
const MARGE := 0.05

func _ready():
	slider.value_changed.connect(_on_slider_value_changed)
	_on_slider_value_changed(slider.value)  # initialise l'affichage
	diode_rouge.visible = true
	diode_verte.visible = false

func _on_slider_value_changed(value: float) -> void:
	var int_part := int(value)
	var frac_part := int((value - int_part) * 10.0)  # dixième
	
	dizaine.text = str((int_part / 10) % 10)
	unite.text = str(int_part % 10)
	dixieme.text = str(frac_part)

func _process(delta: float) -> void:
	Global.Frequence = slider.value
	
	if abs(Global.Frequence - FREQUENCE_CIBLE) < MARGE:
		if not tracking and not Global.ok:
			tracking = true
			timer = 0.0
		elif not Global.ok:
			timer += delta
			if timer >= 1.0:
				# Désactiver le slider ET les boutons
				slider.editable = false
				plus_button.disabled = true
				minus_button.disabled = true
				
				Global.slider_modifiable = false
				Global.ok = true
				
				# Appliquer déplacement et redimensionnement
				position = POSITION_CIBLE
				scale = SCALE_CIBLE
				diode_rouge.visible = false
				diode_verte.visible = true
	else:
		diode_rouge.visible = true
		diode_verte.visible = false
		tracking = false
		timer = 0.0
