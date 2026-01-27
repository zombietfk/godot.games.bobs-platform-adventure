extends LineEdit

var level_path_prefix = "res://level/levels/caves/level_"

func _on_cheat_warp_button_down() -> void:
	if Main.instance.player.get_parent() != Main.instance:
		Main.instance.player.reparent(Main.instance);
	Main.player.global_rotation = 0;
	Main.load_level(
		level_path_prefix + text + ".tscn",
		0
	);
