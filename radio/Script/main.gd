extends Node2D

@onready var slider: HSlider = $Radio/HSlider
@onready var yes: TextureButton = $Bouttons/Yes
@onready var no: TextureButton = $Bouttons/No


func _ready():
	yes.disabled = true
	no.disabled = true
	update_value(slider.value)
	slider.value_changed.connect(update_value)

func update_value(value: float) -> void:
	Global.Frequence = slider.value
