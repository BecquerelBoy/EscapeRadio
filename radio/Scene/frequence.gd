extends Node

@onready var slider := $"../Radio/HSlider"
@onready var dizaine := $Dizaine
@onready var unite := $unité
@onready var dixieme := $dixieme
@onready var win: Sprite2D = $"../win"

var timer := 0.0
var tracking := false

func _ready():
	slider.value_changed.connect(_on_slider_value_changed)
	_on_slider_value_changed(slider.value)  # initialise l'affichage
	win.visible = false

func _on_slider_value_changed(value: float) -> void:
	var int_part := int(value)
	var frac_part := int((value - int_part) * 10.0)  # dixième

	dizaine.text = str((int_part / 10) % 10)
	unite.text = str(int_part % 10)
	dixieme.text = str(frac_part)

func _process(delta: float) -> void:
	Global.Frequence = slider.value
	if abs(Global.Frequence - 82.3) < 0.005: 
		print("win")
		if not tracking:
			tracking = true
			timer = 0.0
		else:
			timer += delta
			if timer >= 1.0:
				slider.editable = false
				Global.ok = true
	else:
		tracking = false
		timer = 0.0
