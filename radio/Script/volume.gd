extends HSlider

@export var bus_name: String

var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	
	if bus_index == -1:
		push_error("Le bus audio '" + bus_name + "' n'existe pas.")
		return
	
	value_changed.connect(_on_value_changed)

@warning_ignore("shadowed_variable_base_class")
func _on_value_changed(value: float) -> void:
	if bus_index != -1:
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(value)
		)
