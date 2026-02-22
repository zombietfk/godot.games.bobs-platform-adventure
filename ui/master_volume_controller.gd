extends HSlider

func _ready()->void:
	_set_volume(value);

func _value_changed(new_value: float)->void:
	_set_volume(new_value);

func _set_volume(to: float):
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		to * 0.8 - 80
	);
