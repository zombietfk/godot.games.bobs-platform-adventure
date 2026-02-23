extends Button

var _stored_floor_snap = 0;

func _fly()->void:
	if Main.instance.player.flying_cheat:
		Main.instance.player.floor_snap_length = _stored_floor_snap;
	else:
		_stored_floor_snap = Main.instance.player.floor_snap_length;
		Main.instance.player.floor_snap_length = 0;
	Main.instance.player.velocity = Vector2.ZERO;
	Main.instance.player.flying_cheat = !Main.instance.player.flying_cheat;
