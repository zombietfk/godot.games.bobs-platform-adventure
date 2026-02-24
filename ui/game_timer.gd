extends Label

var time_in_s := 0.0;

func _process(delta: float)->void:
	time_in_s += delta;
	if Main.show_clock == true:
		visible = true;
		text = _seconds_to_hms(time_in_s);
	else:
		visible = false;
	
func _seconds_to_hms(time_seconds: float) -> String:
	var total_seconds: int = int(time_seconds)
	@warning_ignore("integer_division")
	var hours: int = total_seconds / 3600
	@warning_ignore("integer_division")
	var minutes: int = (total_seconds % 3600) / 60
	var seconds: int = total_seconds % 60
	return "%02d:%02d:%02d" % [hours, minutes, seconds]
