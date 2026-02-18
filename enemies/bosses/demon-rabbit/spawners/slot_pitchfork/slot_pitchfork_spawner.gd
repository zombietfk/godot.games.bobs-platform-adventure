class_name SlotPitchforkSpawner;
extends Node2D;

@export var spawn_points: Array[Marker2D];
@export var pitchfork_scene: PackedScene;

func spawn_pitchforks()->void:
	for spawn_point in spawn_points:
		var pitchfork = pitchfork_scene.instantiate() as SlotPitchfork;
		pitchfork.global_position = spawn_point.global_position;
		Main.instance.level_instance.add_child(pitchfork);
