class_name Mirror;
extends Node2D;

@export var gib_count = 15;

signal on_shatter();

func shatter()->void:
	for i in gib_count:
		Gib.spawn(
			global_position,
			Vector2.ZERO,
			"res://objects/mirror/glass_gibs/glass_gib.tscn"
		);
	print('glassshatter');
	on_shatter.emit();
	queue_free();
