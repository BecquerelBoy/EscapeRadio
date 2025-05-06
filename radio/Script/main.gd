extends Node2D

@onready var slider: HSlider = $Radio/HSlider
@onready var label: Label = $Frequence/Label
@onready var win: Sprite2D = $win

var timer := 0.0
var tracking := false

func _ready():
	update_label(slider.value)
	slider.value_changed.connect(update_label)
	win.visible = false

func update_label(value: float) -> void:
	label.text = "%.1f" % value

func _process(delta: float) -> void:
	if label.text == "81.3":
		if not tracking:
			tracking = true
			timer = 0.0
		else:
			timer += delta
			if timer >= 1.0:
				win.visible = true
	else:
		tracking = false
		timer = 0.0
