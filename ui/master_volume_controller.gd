extends HSlider

@export var use_current_master_volume := false;

func _ready()->void:
	if use_current_master_volume:
		value = (AudioServer.get_bus_volume_db(
			AudioServer.get_bus_index("Master")
		) + 40) / 0.40;
	else:
		_set_volume(value);

func _value_changed(new_value: float)->void:
	_set_volume(new_value);

func _set_volume(to: float):
	if to == 0:
		AudioServer.set_bus_mute(
			AudioServer.get_bus_index("Master"),
			true
		);
	else:
		AudioServer.set_bus_mute(
			AudioServer.get_bus_index("Master"),
			false
		); 
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Master"),
			to * 0.40 - 40
		);

#  = AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master"))\
# v * 0.8 - 80 = d
# (d + 80) / 0.8 
