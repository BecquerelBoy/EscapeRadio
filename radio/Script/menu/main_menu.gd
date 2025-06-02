extends Control

@onready var lampe_a_huile: AnimatedSprite2D = $lampe_a_huile

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	lampe_a_huile.play()
