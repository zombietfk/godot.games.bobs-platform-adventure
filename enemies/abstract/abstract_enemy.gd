@abstract
class_name AbstractEnemy;
extends CharacterBody2D;

@export var gib_count: int = 5;

signal on_death();

func gib_and_kill() -> void:
	for i in gib_count:
		Gib.spawn(global_position, -velocity);
	on_death.emit();
	queue_free();

func _astar_get_next_step_to_target(
	target_global_pos: Vector2,
	pathfind_min_distance: float = 0.0
)->Vector2:
	var distance_to_target = (
		target_global_pos - global_position
	).length();
	if distance_to_target > pathfind_min_distance:
		var path = Main.instance.level_instance.find_path(
			global_position,
			target_global_pos,
		);
		if path.size() > 1:
			return path.get(1) - global_position;
	return (Main.instance.player.global_position - global_position);
