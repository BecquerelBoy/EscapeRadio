extends Node2D

@onready var slider: HSlider = $Radio/HSlider

func _ready():
	update_value(slider.value)
	slider.value_changed.connect(update_value)

func update_value(value: float) -> void:
	Global.Frequence = slider.value
