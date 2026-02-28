extends CheckBox

func _toggle_mobile_combatability()->void:
	Main.mobile_compatabilty_mode = !Main.mobile_compatabilty_mode; 
	print(Main.mobile_compatabilty_mode);
