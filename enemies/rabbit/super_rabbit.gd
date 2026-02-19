class_name SuperRabbit;
extends Node2D;

func _on_hit_demon_bunny(body: Node2D)->void:
	if body is DemonBunny:
		queue_free();
		body.take_damage();
