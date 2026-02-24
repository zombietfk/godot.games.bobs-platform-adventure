extends AnimatedSprite2D

func _play_ending(body: Node2D)->void:
	if body is Player:
		CheckpointSaveManager.set_bobette_unlocked();
		get_tree().change_scene_to_file("res://cutscenes/ending.tscn");
