extends LineEdit

var level_path_prefix = "res://level/levels/caves/level_"

func _on_cheat_warp_button_down() -> void:
	Main.load_level(
		level_path_prefix + text + ".tscn",
		0
	);
