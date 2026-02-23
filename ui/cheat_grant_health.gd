extends Button

func _grant_health()->void:
	Main.instance.player.max_health += 1;
	Main.instance.player.current_health += 1;
