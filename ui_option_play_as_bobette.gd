extends CheckBox;

func _play_as_bobette()->void:
	Player.use_bobette_as_player = !Player.use_bobette_as_player;
