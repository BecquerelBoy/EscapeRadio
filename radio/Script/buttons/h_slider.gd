extends HSlider

func _ready() -> void:
	update_cursor()

func _process(_delta: float) -> void:
	update_cursor()

func update_cursor() -> void:
	if Global.slider_modifiable == false :
		mouse_default_cursor_shape = Control.CURSOR_ARROW
	else:
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
