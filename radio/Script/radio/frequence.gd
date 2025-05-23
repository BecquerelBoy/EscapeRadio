extends Node

@onready var slider := $"../Radio/HSlider"
@onready var dizaine := $Dizaine
@onready var unite := $unité
@onready var dixieme := $dixieme

@onready var audio_1 = $Audio_1

var timer := 0.0
var tracking := false

func _ready():
	slider.value_changed.connect(_on_slider_value_changed)
	_on_slider_value_changed(slider.value)  # initialise l'affichage

func _on_slider_value_changed(value: float) -> void:
	var int_part := int(value)
	var frac_part := int((value - int_part) * 10.0)  # dixième

	dizaine.text = str((int_part / 10) % 10)
	unite.text = str(int_part % 10)
	dixieme.text = str(frac_part)

func _process(delta: float) -> void:
	Global.Frequence = slider.value

	if abs(Global.Frequence - 1.6) < 0.05:
		if not tracking and not Global.ok:
			tracking = true
			timer = 0.0
		elif not Global.ok:
			timer += delta
			if timer >= 1.0:
				slider.editable = false
				Global.slider_modifiable = false
				Global.ok = true  # Verrou activé ici
	else:
		tracking = false
		timer = 0.0
